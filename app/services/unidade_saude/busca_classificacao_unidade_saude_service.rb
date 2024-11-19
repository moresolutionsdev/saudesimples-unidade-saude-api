# frozen_string_literal: true

class UnidadeSaude
  class BuscaClassificacaoUnidadeSaudeService < ApplicationService
    def call
      Success.new(::ClassificacaoUnidadeSaudeRepository.all)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar classificação da unidade de saúde')
    end
  end
end
