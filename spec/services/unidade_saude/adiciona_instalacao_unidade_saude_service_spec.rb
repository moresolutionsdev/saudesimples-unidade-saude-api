# frozen_string_literal: true

RSpec.describe UnidadeSaude::AdicionaInstalacaoUnidadeSaudeService do
  describe '.call' do
    let(:unidade_saude) { create(:unidade_saude, nome: 'Unidade Saude 1') }
    let(:instalacao_fisica) { create(:instalacao_fisica, nome: 'Instalacao 1') }

    context 'when successful' do
      it 'creates a new instalacao_unidade_saude' do
        params = ActionController::Parameters.new(
          instalacao_fisica_id: instalacao_fisica.id,
          qtde_instalacoes: 10,
          qtde_leitos: 50,
          id: unidade_saude.id
        )

        result = described_class.call(params)

        expect(result).to be_success
        expect(result.data).to be_a(InstalacaoUnidadeSaude)
        expect(result.data.instalacao_fisica_id).to eq(instalacao_fisica.id)
        expect(result.data.qtde_instalacoes).to eq(10)
        expect(result.data.qtde_leitos).to eq(50)
      end
    end

    context 'when unidade_saude not found' do
      it 'returns a failure message' do
        params = ActionController::Parameters.new(
          instalacao_fisica_id: instalacao_fisica.id,
          qtde_instalacoes: 10,
          qtde_leitos: 50,
          id: 9999 # ID inválido
        )

        result = described_class.call(params)

        expect(result).to be_failure
        expect(result.error).to eq('Não foi possivel criar a Instalação de Unidade de Saude')
      end
    end

    context 'when instalacao_fisica not found' do
      it 'returns a failure message' do
        params = ActionController::Parameters.new(
          instalacao_fisica_id: 9999,
          qtde_instalacoes: 10,
          qtde_leitos: 50,
          id: unidade_saude.id
        )

        result = described_class.call(params)

        expect(result).to be_failure
        expect(result.error).to eq('Não foi possivel criar a Instalação de Unidade de Saude')
      end
    end
  end
end
