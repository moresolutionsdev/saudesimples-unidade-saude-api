# frozen_string_literal: true

module PadroesAgendas
  class ListagemService < ApplicationService
    def call
      Success.new(listar_padroes_agendas)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao listar padrões de agenda')
    end

    private

    def listar_padroes_agendas
      PadraoAgendaRepository.all
    end
  end
end
