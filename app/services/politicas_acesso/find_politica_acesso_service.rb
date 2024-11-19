# frozen_string_literal: true

module PoliticasAcesso
  class FindPoliticaAcessoService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      politica_acesso = PoliticaAcessoRepository.find_by(documento_tipo: :politica_acesso, id: @id)

      Success.new(politica_acesso)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Politica de Acesso não encontrado')
    end
  end
end
