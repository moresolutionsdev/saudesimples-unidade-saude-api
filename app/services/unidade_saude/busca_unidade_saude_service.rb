# frozen_string_literal: true

class UnidadeSaude
  class BuscaUnidadeSaudeService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      unidade_saude = UnidadeSaude.includes(mantenedora: :municipio).find(@id)

      Success.new(unidade_saude)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      Failure.new("Não foi possível encontrar a unidade de saúde com id #{@id}")
    end
  end
end
