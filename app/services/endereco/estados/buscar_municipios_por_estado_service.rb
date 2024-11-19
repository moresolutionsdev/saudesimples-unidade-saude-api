# frozen_string_literal: true

module Endereco
  module Estados
    class BuscarMunicipiosPorEstadoService < ApplicationService
      def initialize(params)
        @estado_id = params[:estado_id]
      end

      def call
        Success.new(municipios)
      rescue StandardError => e
        Rails.logger.error(e)

        Failure.new('Erro ao listar municipios')
      end

      private

      def municipios
        MunicipioRepository.where(estado_id: @estado_id).order(:nome)
      end
    end
  end
end
