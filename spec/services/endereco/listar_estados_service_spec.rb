# frozen_string_literal: true

RSpec.describe Endereco::ListarEstadosService do
  describe '#call' do
    subject { described_class.call }

    context 'when collection exists' do
      before do
        allow(EstadoRepository).to receive(:all).and_return([])

        subject
      end

      it 'calls repository' do
        expect(EstadoRepository).to have_received(:all)
      end

      it 'return success' do
        expect(subject).to be_a(Success)
      end
    end

    context 'when something went wrong' do
      before do
        allow(EstadoRepository).to receive(:all).and_raise(StandardError)

        subject
      end

      it 'return failure' do
        expect(subject).to be_a(Failure)
      end
    end
  end
end
