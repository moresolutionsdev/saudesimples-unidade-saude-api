# frozen_string_literal: true

RSpec.describe UnidadeSaudeParametrosRepository do
  describe '.find_parametros_by_id' do
    let(:unidade_saude) { create(:unidade_saude, exportacao_esus: true, validacao_municipe: 1) }

    context 'when the UnidadeSaude exists' do
      it 'returns the parameters for the given id' do
        result = described_class.find_parametros_by_id(unidade_saude.id)

        expect(result).to be_present
        expect(result.exportacao_esus).to be true
        expect(result.validacao_municipe).to eq(1)
      end
    end

    context 'when the UnidadeSaude does not exist' do
      it 'returns nil' do
        result = described_class.find_parametros_by_id(9999)

        expect(result).to be_nil
      end
    end
  end
end
