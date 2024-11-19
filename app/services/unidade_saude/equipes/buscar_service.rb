# frozen_string_literal: true

class UnidadeSaude
  module Equipes
    class BuscarService < ApplicationService
      def initialize(params)
        @params = params
      end

      def call
        equipes = ::UnidadeSaude::EquipeRepository.search(@params)

        Success.new(paginate(equipes))
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao listar equipes da unidade de saúde')
      end

      private

      def paginate(equipes)
        equipes.page(@params[:page] || 1).per(@params[:per_page] || 10)
      end
    end
  end
end
