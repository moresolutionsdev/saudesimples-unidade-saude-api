# frozen_string_literal: true

RSpec.describe AgendaMapaPeriodoSerializer, type: :serializer do
  let(:agenda_mapa_periodo) { create(:agenda_mapa_periodo) }

  let(:serialized_periodo) { described_class.render_as_hash(agenda_mapa_periodo) }

  it 'serializes the correct fields' do
    expect(serialized_periodo).to include(
      id: agenda_mapa_periodo.id,
      data_inicial: agenda_mapa_periodo.data_inicial,
      data_final: agenda_mapa_periodo.data_final,
      possui_horario_distribuido: agenda_mapa_periodo.possui_horario_distribuido,
      possui_tempo_atendimento_configurado: agenda_mapa_periodo.possui_tempo_atendimento_configurado,
      inativo: agenda_mapa_periodo.inativo,
      dias_agendamento: agenda_mapa_periodo.dias_agendamento,
      data_liberacao_agendamento: agenda_mapa_periodo.data_liberacao_agendamento
    )
  end

  it 'serializes the associated agenda_mapa_dias' do
    expect(serialized_periodo[:agenda_mapa_dias]).to be_an(Array)
  end
end
