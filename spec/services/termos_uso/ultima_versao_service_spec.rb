# frozen_string_literal: true

RSpec.describe TermosUso::UltimaVersaoService, type: :service do
  describe '#call' do
    let!(:termo_uso_atual) { create(:termo_uso, documento_tipo: 'termo_uso', versao: 2) }
    let!(:termo_uso_antigo) { create(:termo_uso, documento_tipo: 'termo_uso', versao: 1) }

    context 'when there is a termo de uso with the highest version' do
      before do
        allow(TermoUsoRepository).to receive(:last_version).and_return(termo_uso_atual)
      end

      it 'returns a success object with the latest termo de uso' do
        result = described_class.call

        expect(result).to be_success
        expect(result.data).to eq(termo_uso_atual)
      end
    end

    context 'when no termo de uso is found' do
      before do
        allow(TermoUsoRepository).to receive(:last_version)
          .and_raise(StandardError.new('Nenhum termo de uso encontrado'))
      end

      it 'returns a failure object with an error message' do
        result = described_class.call

        expect(result).to be_failure
        expect(result.error).to eq('Nenhum termo de uso encontrado')
      end
    end
  end
end
