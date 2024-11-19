# frozen_string_literal: true

RSpec.describe TermosUso::FindTermoUsoService do
  describe '#call' do
    let!(:termo_uso) { create(:termo_uso) }
    let(:service) { described_class.new(termo_uso.id) }

    context 'when the term is found' do
      before do
        # Simula o comportamento esperado do repositório quando o termo é encontrado
        allow(TermoUsoRepository).to receive(:find_by).with(id: termo_uso.id).and_return(termo_uso)
      end

      it 'returns a Success result' do
        result = service.call
        expect(result).to be_success
        expect(result.data).to eq(termo_uso)
      end
    end

    context 'when an error occurs' do
      before do
        # Simula uma exceção sendo levantada pelo repositório
        allow(TermoUsoRepository).to receive(:find_by).with(id: termo_uso.id).and_raise(StandardError)
      end

      it 'returns a Failure result with an error message' do
        result = service.call
        expect(result).to be_failure
        expect(result.error).to eq('Termo de uso não encontrado')
      end
    end
  end
end
