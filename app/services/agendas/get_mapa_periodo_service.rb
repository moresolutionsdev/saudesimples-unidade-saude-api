# frozen_string_literal: true

module Agendas
  class GetMapaPeriodoService < ApplicationService
    def initialize(mapa_periodo_id)
      @mapa_periodo_id = mapa_periodo_id
    end

    def call
      Success.new(AgendaMapaPeriodoRepository.find(@mapa_periodo_id))
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar periodo da agenda')
    end
  end
end
