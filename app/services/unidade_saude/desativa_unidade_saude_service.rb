# frozen_string_literal: true

class UnidadeSaude
  class DesativaUnidadeSaudeService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      unidade_saude = ::UnidadeSaudeRepository.new({ id: @id })
      unidade_saude.deactivate

      {
        success: true,
        data: { unidade_saude: }
      }
    rescue StandardError
      { error: 'Erro ao desativar unidade de saúde' }
    end
  end
end
