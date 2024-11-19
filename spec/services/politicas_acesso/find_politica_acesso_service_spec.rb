# frozen_string_literal: true

RSpec.describe PoliticasAcesso::FindPoliticaAcessoService do
  describe '#call' do
    let!(:termo_uso) { create(:termo_uso, documento_tipo: 'politica_acesso') }
    let(:service) { described_class.new(termo_uso.id) }

    context 'when the term is found' do
      before do
        allow(TermoUsoRepository).to receive(:find_by).with(id: termo_uso.id).and_return(termo_uso)
      end

      it 'returns a Success result' do
        result = service.call
        expect(result).to be_success
        expect(result.data).to eq(termo_uso)
      end
    end
  end
end
