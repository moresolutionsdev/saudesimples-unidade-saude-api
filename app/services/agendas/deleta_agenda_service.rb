# frozen_string_literal: true

module Agendas
  class DeletaAgendaService < ApplicationService
    def initialize(agenda_id)
      @agenda_id = agenda_id
    end

    def call
      agenda_exist?
      can_delete?
      Success.new(delete_agenda)
    rescue ArgumentError => e
      Rails.logger.error(e.message)
      Failure.new({ error: e.message, status: 400 })
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new(e.message)
    end

    private

    def can_delete?
      return false unless AgendaRepository.historico_agendamentos?(@agenda_id, agendamento_ids)

      raise 'Agenda tem historico.'
    end

    def agenda_exist?
      return true if AgendaRepository.exist?(@agenda_id)

      raise 'Agenda inválida'
    end

    def delete_agenda
      AgendaRepository.delete_agenda(@agenda_id)
    end

    def agendamento_ids
      @agendamento_ids ||= AgendamentoRepository.agendamento_ids(@agenda_id)
    end
  end
end
