# frozen_string_literal: true

class UnidadeSaude
  module Agendas
    class UpdateMapaPeriodoService < ApplicationService
      def initialize(mapa_periodo_id, params)
        @mapa_periodo_id = mapa_periodo_id
        @params = params
      end

      def call
        mapa_periodo = AgendaMapaPeriodoRepository.update_with_associations(@mapa_periodo_id, @params)

        success(mapa_periodo)
      rescue StandardError => e
        Rails.logger.error(e)
        failure(e.message)
      end
    end
  end
end
