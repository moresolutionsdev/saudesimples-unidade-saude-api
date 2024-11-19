# frozen_string_literal: true

class UnidadeSaude
  class NovaUnidadeSaudeService < ApplicationService
    attr_reader :params

    def initialize(params)
      @unidade_saude_params = params.except(:horarios_funcionamento, :mantenedora, :administrador_id, :municipio)
      @horarios_funcionamento = params[:horarios_funcionamento]
      @mantenedora = params[:mantenedora]
      @municipio_id = params[:municipio_id]
      @estado_id = params[:estado_id]
    end

    def call
      @unidade_saude_params[:tipo_unidade_id] = @unidade_saude_params.delete(:codigo_tipo_unidade)

      unidade_saude = ::UnidadeSaudeRepository.create(@unidade_saude_params.merge(municipio_id: @municipio_id,
                                                                                  estado_id: @estado_id))
      return { success: false, errors: 'Erro ao criar a unidade de saúde' } unless unidade_saude.persisted?

      definir_horarios_funcionamento(unidade_saude)

      if mantenedora_valida?
        municipio = Municipio.find_by(id: @municipio_id)
        return { success: false, errors: "Município não encontrado com ID #{@municipio_id}" } unless municipio

        mantenedora = ::MantenedoraRepository.create(
          @mantenedora.merge(estado_id: @estado_id, municipio_id: municipio.id)
        )
        return { success: false, errors: 'Erro ao criar a mantenedora' } unless mantenedora.persisted?

        unidade_saude.update(mantenedora_id: mantenedora.id)
      end

      { success: true, unidade_saude: }
    rescue StandardError => e
      { success: false, errors: "Erro ao processar a operação: #{e.message}" }
    end

    private

    def mantenedora_valida?
      @mantenedora.present? && @mantenedora.values.any?(&:present?)
    end

    def definir_horarios_funcionamento(nova_unidade_saude)
      return unless @horarios_funcionamento.is_a?(Array) && !@horarios_funcionamento.empty?

      @horarios_funcionamento.each do |horario_params|
        next unless horario_params[:horario_inicio].present? && horario_params[:horario_encerramento].present?

        ::Atendimento::SetHorarioAtendimentoService.new({
          unidade_saude_id: nova_unidade_saude.id,
          dia_semana: horario_params[:dia_semana],
          horario_inicio: horario_params[:horario_inicio],
          horario_encerramento: horario_params[:horario_encerramento]
        }).call
      end
    end

    def vincula_mantenedora(nova_unidade_saude)
      result = ::UnidadeSaude::VinculaMantenedoraUnidadeSaudeService.call({
        unidade_saude_id: nova_unidade_saude.id,
        mantenedora: @mantenedora
      })

      raise StandardError, result[:errors] unless result[:success]

      nova_unidade_saude.update!(mantenedora_id: result[:unidade_saude].mantenedora_id)
    end
  end
end
