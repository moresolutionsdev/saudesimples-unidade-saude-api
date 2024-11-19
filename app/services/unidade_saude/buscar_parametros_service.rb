# frozen_string_literal: true

class UnidadeSaude
  class BuscarParametrosService < ApplicationService
    def initialize(params)
      @unidade_saude_id = params[:unidade_saude_id]
    end
    attr_reader :unidade_saude_id

    def call
      parametros = UnidadeSaudeParametrosRepository.find_parametros_by_id(unidade_saude_id)

      return Success.new(parametros) if parametros.present?

      Failure.new('Unidade de Saúde não encontrada')
    rescue StandardError => e
      Rails.logger.error(e.message)
      Failure.new('Falha ao buscar parâmetros da Unidade de Saúde')
    end
  end
end
