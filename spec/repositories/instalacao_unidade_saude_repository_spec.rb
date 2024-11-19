# frozen_string_literal: true

RSpec.describe InstalacaoUnidadeSaudeRepository do
  describe '.create!' do
    let(:unidade_saude) { create(:unidade_saude, nome: 'Unidade Saude 1') }
    let(:instalacao_fisica) { create(:instalacao_fisica, nome: 'Instalacao 1') }

    context 'when creating successfully' do
      it 'creates a new instalacao_unidade_saude' do
        result = described_class.create!(
          unidade_saude.id,
          instalacao_fisica.id,
          10,
          50
        )

        expect(result).to be_a(InstalacaoUnidadeSaude)
        expect(result.unidade_saude_id).to eq(unidade_saude.id)
        expect(result.instalacao_fisica_id).to eq(instalacao_fisica.id)
        expect(result.qtde_instalacoes).to eq(10)
        expect(result.qtde_leitos).to eq(50)
      end
    end

    context 'when validation fails' do
      it 'raises an error' do
        expect do
          described_class.create!(
            unidade_saude.id,
            instalacao_fisica.id,
            nil,
            50
          )
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
