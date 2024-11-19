# frozen_string_literal: true

RSpec.describe PoliticasAcesso::UltimaVersaoService, type: :service do
  describe '#call' do
    let!(:termo_uso_atual) { create(:termo_uso, documento_tipo: 'politica_acesso', versao: 2) }
    let!(:termo_uso_antigo) { create(:termo_uso, documento_tipo: 'politica_acesso', versao: 1) }

    context 'when there is a politica_acesso de uso with the highest version' do
      before do
        allow(PoliticaAcessoRepository).to receive(:last_version).and_return(termo_uso_atual)
      end

      it 'returns a success object with the latest politica_acesso' do
        result = described_class.call

        expect(result).to be_success
        expect(result.data).to eq(termo_uso_atual)
      end
    end

    context 'when no politica_acesso is found' do
      before do
        allow(PoliticaAcessoRepository).to receive(:last_version)
          .and_raise(StandardError.new('Nenhuma Politica de acesso encontrada'))
      end

      it 'returns a failure object with an error message' do
        result = described_class.call

        expect(result).to be_failure
        expect(result.error).to eq('Nenhuma Politica de acesso encontrada')
      end
    end
  end
end
