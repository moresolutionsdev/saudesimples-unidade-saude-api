# frozen_string_literal: true

module Agendas
  class BloquearAgendaService < ApplicationService
    def initialize(agenda_id:, params:)
      @agenda_id = agenda_id
      @params = params
    end

    def call
      return Failure.new('Período de bloqueio já cadastrado') if data_ja_cadastrada?

      if replicar_bloqueio?(@params.delete(:replicar_bloqueio))
        criar_bloqueios_em_todas_agendas
      else
        agenda.agendas_bloqueios.create!(@params)
      end

      Success.new(true)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Algo deu errado, tente novamente.')
    end

    private

    def agenda
      @agenda ||= AgendaRepository.find(@agenda_id)
    end

    def data_ja_cadastrada?
      agenda.agendas_bloqueios.exists?(
        data_inicio: @params[:data_inicio],
        data_fim: @params[:data_fim],
        hora_inicio: @params[:hora_inicio],
        hora_fim: @params[:hora_fim]
      )
    end

    def replicar_bloqueio?(replicar_bloqueio)
      replicar_bloqueio
    end

    def criar_bloqueios_em_todas_agendas
      @params[:automatico] = true

      agenda.agendas_bloqueios.create!(@params)

      agendas = listar_todas_agendas_de_profissonal_e_unidade_saude
      agendas.each do |agenda|
        agenda.agendas_bloqueios.create!(@params)
      end
    end

    def listar_todas_agendas_de_profissonal_e_unidade_saude
      AgendaRepository
        .joins(:unidade_saude_ocupacao)
        .where(unidade_saude_ocupacao: { unidade_saude_id: agenda.unidade_saude_ocupacao.unidade_saude_id })
        .where(profissional_id: agenda.profissional_id)
        .where.not(id: agenda.id)
    end
  end
end
