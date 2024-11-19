# frozen_string_literal: true

class AgendaMapaPeriodoSerializer < ApplicationSerializer
  identifier :id

  fields :data_inicial, :data_final, :possui_horario_distribuido, :possui_tempo_atendimento_configurado, :inativo,
         :dias_agendamento, :data_liberacao_agendamento

  # Associações para serializar os dias e horários
  association :agenda_mapa_dias, blueprint: AgendaMapaDiaSerializer
end
