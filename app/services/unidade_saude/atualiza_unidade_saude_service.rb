# frozen_string_literal: true

class UnidadeSaude
  class AtualizaUnidadeSaudeService < ApplicationService
    attr_reader :params

    def initialize(params, validate: false)
      params.deep_symbolize_keys!

      @validate = validate
      @unidade_saude_params = params.except(:horarios_funcionamento, :mantenedora, :municipio, :administrador_id)
      @horarios_funcionamento = params[:horarios_funcionamento]
      @mantenedora_params = params[:mantenedora] if params[:mantenedora]
      return unless @unidade_saude_params[:codigo_tipo_unidade]

      @unidade_saude_params[:tipo_unidade_id] =
        @unidade_saude_params.delete(:codigo_tipo_unidade)
    end

    def call
      validar_unidade_se_necessario
      unidade_saude = atualizar_unidade_saude
      atualizar_horarios_funcionamento(unidade_saude)
      atualizar_mantenedora(unidade_saude)

      Success.new(unidade_saude)
    rescue StandardError => e
      Rails.logger.error("Erro ao atualizar unidade de saúde: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      Failure.new("Erro ao atualizar unidade de saúde: #{e.message}")
    end

    private

    def validar_unidade_se_necessario
      return unless @validate

      result = validar_unidade_saude
      raise StandardError, result[:errors] if result[:errors].any?
    end

    def atualizar_unidade_saude
      ::UnidadeSaudeRepository.update(@unidade_saude_params)
    end

    def atualizar_horarios_funcionamento(unidade_saude)
      return unless @horarios_funcionamento.is_a?(Array) && @horarios_funcionamento.present?

      @horarios_funcionamento.each do |horario_params|
        next unless horario_params[:horario_inicio].present? && horario_params[:horario_encerramento].present?

        ::Atendimento::SetHorarioAtendimentoService.call({
          unidade_saude_id: unidade_saude.id,
          dia_semana: horario_params[:dia_semana],
          horario_inicio: horario_params[:horario_inicio],
          horario_encerramento: horario_params[:horario_encerramento]
        })
      end
    end

    def atualizar_mantenedora(unidade_saude)
      return if @mantenedora_params.blank?

      if unidade_saude.mantenedora_id.present?
        mantenedora = ::Mantenedora.find_by(id: unidade_saude.mantenedora_id)
        raise StandardError, "Mantenedora com ID #{unidade_saude.mantenedora_id} não encontrada" if mantenedora.blank?

        mantenedora.update!(@mantenedora_params)
      else
        vincula_mantenedora(unidade_saude)
      end
    end

    def validar_unidade_saude
      errors = []

      campos_obrigatorios = %i[cep estado_id municipio_id logradouro bairro]
      campos_obrigatorios << %i[razao_social cnpj_numero] if @unidade_saude_params
        .symbolize_keys[:tipo_pessoa_cnes_id] == '1'
      campos_obrigatorios << %i[nome cpf_numero] if @unidade_saude_params
        .symbolize_keys[:tipo_pessoa_cnes_id] == '2'

      campos_obrigatorios.flatten.each_with_object(errors) do |campo, error|
        error << "'#{campo}' não pode estar vazio" if @unidade_saude_params
          .symbolize_keys[campo].blank?
      end

      { errors: }
    end

    def vincula_mantenedora(unidade_saude)
      result = ::UnidadeSaude::VinculaMantenedoraUnidadeSaudeService.call({
        unidade_saude_id: unidade_saude.id,
        mantenedora: @mantenedora_params
      })

      raise StandardError, result[:errors] unless result[:success]

      unidade_saude.update!(mantenedora_id: result[:unidade_saude].mantenedora_id)
    end
  end
end
