# frozen_string_literal: true

RSpec.describe AgendaBloqueioSerializer do
  let(:agenda_bloqueio) { create(:agenda_bloqueio) }
  let(:serialized_resource) { described_class.render_as_hash(agenda_bloqueio) }
  let(:tipo_bloqueio) { TipoBloqueioSerializer.render_as_hash(agenda_bloqueio.tipo_bloqueio) }
  let(:actions) do
    { 'delete' => false }
  end

  describe '#render_as_hash' do
    it do
      expect(serialized_resource).to include(
        id: agenda_bloqueio.id,
        data_inicio: agenda_bloqueio.data_inicio,
        data_fim: agenda_bloqueio.data_fim,
        hora_inicio: agenda_bloqueio.hora_inicio,
        hora_fim: agenda_bloqueio.hora_fim,
        motivo: agenda_bloqueio.motivo,
        automatico: agenda_bloqueio.automatico,
        tipo_bloqueio:,
        actions:
      )
    end
  end
end
