# frozen_string_literal: true

module Ferramentas
  class Parametrizacao
    class UpdateService < ApplicationService
      def initialize(params)
        @id = params[:id]
        @params = params
      end

      def call
        find
        update

        success(@parametrizacao)
      rescue StandardError => e
        Rails.logger.error(e)

        failure(e.message)
      end

      private

      def find
        @parametrizacao = Ferramentas::ParametrizacaoRepository.find(@id)
      end

      def update
        @parametrizacao.update!(@params)
      end
    end
  end
end
