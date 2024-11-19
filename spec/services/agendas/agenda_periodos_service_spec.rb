# frozen_string_literal: true

RSpec.describe Agendas::AgendaPeriodosService do
  describe '#call' do
    subject { described_class.call(id_agenda, filter_params) }

    let(:id_agenda) { '1' }
    let(:filter_params) do
      {
        data_inicial: '2024-10-01',
        data_final: '2024-10-10',
        inativo: false,
        order: 'data_inicial',
        order_direction: 'ASC'
      }
    end

    context 'when service runs successfully' do
      let(:periodo_mock) { double('Periodo', id: 1, data_inicial: '2024-10-01', data_final: '2024-10-10') }

      before do
        allow_any_instance_of(described_class).to receive(:get_periodos).and_return([periodo_mock])
      end

      it 'returns a Success object' do
        result = subject
        expect(result.success?).to be true
      end
    end

    context 'when service fails due to an exception' do
      before do
        allow_any_instance_of(described_class).to receive(:get_periodos).and_raise(StandardError, 'Some error')
      end

      it 'returns a Failure object with an error message' do
        result = subject
        expect(result.failure?).to be true
      end
    end
  end
end
