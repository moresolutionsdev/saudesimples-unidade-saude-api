# frozen_string_literal: true

module Equipes
  module Profissionais
    class ListarService < ApplicationService
      def initialize(params)
        @params = params
      end

      def call
        profissionais = ::EquipeProfissionalRepository.search(@params)

        Success.new(paginate(profissionais))
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao listar profissionais da equipe')
      end

      private

      def paginate(profissionais)
        profissionais.page(@params[:page]).per(@params[:per_page])
      end
    end
  end
end
