# frozen_string_literal: true

RSpec.describe UnidadeSaudeOcupacaoSerializer do
  let(:unidade_saude) { build(:unidade_saude, id: 1, nome: 'Unidade de Saúde Central') }
  let(:ocupacao) { build(:ocupacao, id: 2, nome: 'Médico', codigo: 'MED123', saude: true) }
  let(:unidade_saude_ocupacao) do
    build(:unidade_saude_ocupacao, id: 3, unidade_saude:, ocupacao:)
  end

  describe 'UnidadeSaudeOcupacaoSerializer#render_as_hash' do
    context 'when using the agenda view' do
      it 'serializes the unidade_saude_ocupacao correctly' do
        result = described_class.render(unidade_saude_ocupacao, view: :listagem_agenda)

        expect(JSON.parse(result, symbolize_names: true)).to eq(
          id: 3,
          unidade_saude: {
            id: 1,
            nome: 'Unidade de Saúde Central'
          },
          ocupacao: {
            id: 2,
            nome: 'Médico',
            codigo: 'MED123',
            saude: true
          }
        )
      end
    end
  end
end
