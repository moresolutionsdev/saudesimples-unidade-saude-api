# frozen_string_literal: true

class AgendaPeriodoSerializer < ApplicationSerializer
  identifier :id

  fields :data_inicial, :data_final, :possui_horario_distribuido, :possui_tempo_atendimento_configurado,
         :inativo, :dias_agendamento, :data_liberacao_agendamento

  # association :agenda_mapa_periodo_tempo_atendimentos, blueprint: AgendaMapaPeriodoTempoAtendimentoSerializer
  field :agenda_mapa_periodo_tempo_atendimentos do |agenda_periodo|
    tempo_atendimento = agenda_periodo.agenda_mapa_periodo_tempo_atendimentos.last

    AgendaMapaPeriodoTempoAtendimentoSerializer.render_as_hash(tempo_atendimento) if tempo_atendimento.present?
  end
  association :agenda_mapa_dias, blueprint: AgendaMapaDiaSerializer
end
