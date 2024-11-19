# frozen_string_literal: true

class UnidadeSaude
  class VinculaMantenedoraUnidadeSaudeService < ApplicationService
    def initialize(params)
      @id = params[:unidade_saude_id]
      @mantenedora_params = params[:mantenedora].except(:estado_id, :tipo_logradouro_id, :numero, :agencia)
      @estado_id = params[:mantenedora][:estado_id]
      @municipio_id = params[:mantenedora][:municipio_id]
    end

    def call
      return { success: false, errors: 'Dados da mantenedora estão incompletos' } unless mantenedora_valida?

      municipio = Municipio.find_by(id: @municipio_id)
      return { success: false, errors: "Município não encontrado com ID #{@municipio_id}" } unless municipio

      mantenedora = ::Mantenedora.new(
        @mantenedora_params.merge(estado_id: @estado_id, municipio_id: municipio.id)
      )

      if mantenedora.save
        unidade_saude = ::UnidadeSaudeRepository.set_mantenedora(unidade_saude_id: @id, mantenedora_id: mantenedora.id)

        if unidade_saude
          { success: true, unidade_saude: }
        else
          { success: false, errors: 'Erro ao vincular a mantenedora à unidade de saúde' }
        end
      else
        { success: false, errors: mantenedora.errors.full_messages.join(', ') }
      end
    rescue StandardError => e
      { success: false, errors: "Erro ao processar a operação de mantenedora: #{e.message}" }
    end

    private

    def mantenedora_valida?
      @mantenedora_params.values.any?(&:present?)
    end
  end
end
