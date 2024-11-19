# frozen_string_literal: true

module PoliticasAcesso
  class CreatePoliticaAcessoService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      politica_acesso = PoliticaAcessoRepository.create!(@params)

      Success.new(politica_acesso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao criar a Politica de acesso')
    end
  end
end
