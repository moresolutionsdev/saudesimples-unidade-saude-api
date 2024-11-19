# frozen_string_literal: true

class AgendaMapaDiaSerializer < ApplicationSerializer
  identifier :id

  fields :dia_atendimento_id

  field :dia_atendimento do |mapa_dia|
    DiaAtendimento.where(id: mapa_dia.dia_atendimento_id).last&.nome
  end

  # Associações para serializar os horários
  association :agenda_mapa_horarios, blueprint: AgendaMapaHorarioSerializer
end
