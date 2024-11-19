# frozen_string_literal: true

class UnidadeSaude
  class DeletaInstalacaoUnidadeSaudeService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      ::InstalacaoUnidadeSaudeRepository.destroy!(@id)
      Success.new(true)
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error(e)
      Failure.new('Erro ao remover instalação fisica')
    end
  end
end
