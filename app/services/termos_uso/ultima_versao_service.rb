# frozen_string_literal: true

module TermosUso
  class UltimaVersaoService < ApplicationService
    def call
      termo_uso = TermoUsoRepository.last_version

      Success.new(termo_uso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Nenhum termo de uso encontrado')
    end
  end
end
