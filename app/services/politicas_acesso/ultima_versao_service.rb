# frozen_string_literal: true

module PoliticasAcesso
  class UltimaVersaoService < ApplicationService
    def call
      termo_uso = PoliticaAcessoRepository.last_version

      Success.new(termo_uso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Nenhuma Politica de acesso encontrada')
    end
  end
end
