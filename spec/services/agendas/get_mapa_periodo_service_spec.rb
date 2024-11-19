# frozen_string_literal: true

RSpec.describe Agendas::GetMapaPeriodoService do
  describe '#call' do
    subject { described_class.call(agenda_mapa_periodo.id) }

    let(:agenda) { create(:agenda) }
    let!(:agenda_mapa_periodo) { create(:agenda_mapa_periodo, agenda_id: agenda.id) }

    context 'when service runs successfully' do
      it 'returns a Success object' do
        result = subject
        expect(result.success?).to be true
      end

      it 'returns a correctly object' do
        result = subject.data
        expect(result).to eq(agenda_mapa_periodo)
      end
    end

    context 'when service fails due to an exception' do
      it 'returns a Failure object' do
        result = described_class.call('invalid_id')
        expect(result.failure?).to be true
      end

      it 'returns a Failure object with an error message' do
        result = described_class.call(nil)
        expect(result.error).to eq('Erro ao buscar periodo da agenda')
      end
    end
  end
end
