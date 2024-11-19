# frozen_string_literal: true

RSpec.describe Agendas::Bloqueios::ListarService, type: :service do
  before do
    # Limpa o cache de valores únicos pra resolver o erro Retry limit exceeded for number
    Faker::UniqueGenerator.clear
  end

  let!(:agenda) { create(:agenda) }
  let!(:agenda_bloqueio) { create(:agenda_bloqueio, id: 1,  agenda:) }
  let(:params) { { agenda_id: agenda.id, page: 1, per_page: 10 } }

  describe '#call' do
    context 'when the service is successful' do
      it 'returns a success result' do
        result = described_class.call(params)

        expect(result).to be_success
      end
    end

    context 'when an error occurs' do
      it 'returns a failure result' do
        allow(AgendaBloqueioRepository).to receive(:search).and_raise(StandardError)

        result = described_class.call(params)

        expect(result).to be_failure
      end
    end
  end
end
