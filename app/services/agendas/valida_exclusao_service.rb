# frozen_string_literal: true

module Agendas
  class ValidaExclusaoService < ApplicationService
    def initialize(agenda_id)
      @agenda_id = agenda_id
    end

    def call
      if existe_agendamentos?
        Success.new('false')
      else
        Success.new('true')
      end
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end

    private

    def existe_agendamentos?
      AgendaRepository.historico_agendamentos?(@agenda_id, agendamento_ids)
    end

    def agendamento_ids
      @agendamento_ids ||= AgendamentoRepository.agendamento_ids(@agenda_id)
    end
  end
end
