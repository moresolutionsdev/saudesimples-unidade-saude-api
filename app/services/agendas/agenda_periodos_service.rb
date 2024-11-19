# frozen_string_literal: true

module Agendas
  class AgendaPeriodosService < ApplicationService
    def initialize(id_agenda, filter_params)
      @id_agenda = id_agenda
      @filter_params = filter_params
    end

    def call
      periodo = get_periodos(@id_agenda, @filter_params)

      Success.new(periodo)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar periodo da agenda')
    end

    private

    def get_periodos(id_agenda, filter_params)
      # rubocop:disable Rails/DynamicFindBy
      AgendaMapaPeriodoRepository.find_by_agenda_and_filters(id_agenda, filter_params)
      # rubocop:enable Rails/DynamicFindBy
    end
  end
end
