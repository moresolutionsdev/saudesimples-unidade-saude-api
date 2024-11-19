# frozen_string_literal: true

RSpec.describe ProfissionalSerializer do
  let(:profissional) { build(:profissional, id: 1, nome: 'Profissional X', codigo: 'ABC123') }

  describe 'ProfissionalSerializer#render_as_hash' do
    context 'when using the agenda view' do
      it 'serializes the profissional correctly' do
        result = described_class.render(profissional, view: :listagem_agenda)

        expect(JSON.parse(result, symbolize_names: true)).to eq(
          id: 1,
          codigo: 'ABC123',
          nome: 'Profissional X'
        )
      end
    end
  end
end
