# frozen_string_literal: true

class AgendaMapaHorarioSerializer < ApplicationSerializer
  identifier :id

  fields :hora_inicio, :hora_fim, :nova_consulta, :retorno, :reserva_tecnica,
         :regulacao, :regulacao_retorno, :observacao

  field :hora_inicio do |mapa_horario|
    mapa_horario.hora_inicio.strftime('%H:%M')
  end

  field :hora_fim do |mapa_horario|
    mapa_horario.hora_fim.strftime('%H:%M')
  end
end
