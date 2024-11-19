# frozen_string_literal: true

module Atendimento
  class SetHorarioAtendimentoService < ApplicationService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      dia_atendimento = ::AtendimentoRepository.find_dia_atendimento_by_nome(params[:dia_semana])

      horario = ::AtendimentoRepository.upsert_dia_atendimento(
        params[:unidade_saude_id],
        dia_atendimento_id: dia_atendimento.id,
        horario_inicio: params[:horario_inicio],
        horario_encerramento: params[:horario_encerramento]
      )

      Success.new(horario)
    rescue StandardError
      Failure.new('Erro ao criar horario de atendimento')
    end
  end
end
