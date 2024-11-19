# frozen_string_literal: true

class UnidadeSaude
  module Equipes
    class SearchService < ApplicationService
      def initialize(params)
        @unidade_saude_id = params[:unidade_saude_id]
        @params = params
      end

      def call
        equipes = ::UnidadeSaude::EquipeRepository.search(@unidade_saude_id, @params)

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
