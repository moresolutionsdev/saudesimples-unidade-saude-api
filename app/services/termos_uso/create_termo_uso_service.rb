# frozen_string_literal: true

module TermosUso
  class CreateTermoUsoService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      termo_uso = TermoUsoRepository.create!(@params)
      Success.new(termo_uso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao salvar Termo de Uso')
    end
  end
end
