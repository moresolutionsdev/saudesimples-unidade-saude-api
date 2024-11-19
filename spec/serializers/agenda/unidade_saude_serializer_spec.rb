# frozen_string_literal: true

RSpec.describe UnidadeSaudeSerializer do
  let(:unidade_saude) { build(:unidade_saude, id: 1, nome: 'Unidade de Saúde Central') }

  describe 'UnidadeSaudeSerializer#render_as_hash' do
    context 'when using the agenda view' do
      it 'serializes the unidade_saude correctly' do
        result = described_class.render(unidade_saude, view: :listagem_agenda)

        expect(JSON.parse(result, symbolize_names: true)).to eq(
          id: 1,
          nome: 'Unidade de Saúde Central'
        )
      end
    end
  end
end
