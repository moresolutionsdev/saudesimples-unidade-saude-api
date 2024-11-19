# frozen_string_literal: true

RSpec.describe EquipamentoSerializer do
  let(:tipo_equipamento) { build(:tipo_equipamento, id: 2, nome: 'Tipo A', codigo: '123') }
  let(:equipamento) do
    build(:equipamento, id: 1, nome: 'Equipamento X', codigo: '456', tipo_equipamento:)
  end

  describe 'EquipamentoSerializer#render_as_hash' do
    context 'when using the agenda view' do
      it 'serializes the equipamento correctly' do
        result = described_class.render(equipamento, view: :listagem_agenda)

        expect(JSON.parse(result, symbolize_names: true)).to eq(
          id: 1,
          codigo: '456',
          nome: 'Equipamento X',
          tipo_equipamento: {
            id: 2,
            nome: 'Tipo A',
            codigo: '123'
          }
        )
      end
    end
  end
end
