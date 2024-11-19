# frozen_string_literal: true

class UnidadeSaude
  module Agendas
    class BuscarAgendaService < ApplicationService
      def initialize(id)
        @id = id
      end

      def call
        agenda = Agenda.includes(
          :profissional,
          :padrao_agenda,
          :procedimento,
          unidade_saude_ocupacao: %i[
            unidade_saude
            ocupacao
          ],
          equipamento_utilizavel: %i[
            equipamento
            tipo_equipamento
            unidade_saude
          ]
        ).find(@id)

        Success.new(agenda)
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error(e)

        Failure.new("Não foi possivel encontrar a agenda com id #{@id}")
      end
    end
  end
end
