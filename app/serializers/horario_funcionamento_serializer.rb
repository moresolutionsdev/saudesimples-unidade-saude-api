# frozen_string_literal: true

class HorarioFuncionamentoSerializer < ApplicationSerializer
  fields :dia_semana, :horario_inicio, :horario_encerramento

  field :horario_inicio do |horario_funcionamento|
    horario_funcionamento.hora_inicio&.strftime('%H:%M')
  end

  field :horario_encerramento do |horario_funcionamento|
    horario_funcionamento.hora_fim&.strftime('%H:%M')
  end
end
