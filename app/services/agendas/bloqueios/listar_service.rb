# frozen_string_literal: true

module Agendas
  module Bloqueios
    class ListarService < ApplicationService
      def initialize(params)
        @params = params
      end

      def call
        bloqueios = ::AgendaBloqueioRepository.search(@params)

        Success.new(paginate(bloqueios))
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao listar bloqueios da agenda')
      end

      private

      def paginate(bloqueios)
        bloqueios.page(@params[:page]).per(@params[:per_page])
      end
    end
  end
end
