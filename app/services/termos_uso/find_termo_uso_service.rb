# frozen_string_literal: true

module TermosUso
  class FindTermoUsoService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      termo_uso = TermoUsoRepository.find_by(id: @id)

      Success.new(termo_uso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Termo de uso não encontrado')
    end
  end
end
