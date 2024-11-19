# frozen_string_literal: true

module Ferramentas
  class Parametrizacao
    class ListarService < ApplicationService
      def call
        parametrizacao = Ferramentas::ParametrizacaoRepository.first

        success(parametrizacao)
      rescue StandardError => e
        Rails.logger.error(e)

        failure(e.message)
      end
    end
  end
end
