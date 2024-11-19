# frozen_string_literal: true

RSpec.describe EquipamentoUtilizavelSerializer do
  let(:tipo_equipamento) { build(:tipo_equipamento, id: 1, nome: 'Tipo A', codigo: 'TE123') }
  let(:equipamento) do
    build(:equipamento, id: 2, nome: 'Equipamento X', codigo: 'EQ456', tipo_equipamento:)
  end
  let(:equipamento_utilizavel) do
    build(:equipamento_utilizavel,
          id: 3,
          nome: 'Equipamento Utilizável Y',
          fabricante: 'Fabricante Z',
          numero_serie: 'SN789',
          equipamento:,
          tipo_equipamento:)
  end

  describe 'EquipamentoUtilizavelSerializer#render_as_hash' do
    context 'when using the agenda view' do
      it 'serializes the equipamento_utilizavel correctly' do
        result = described_class.render(equipamento_utilizavel, view: :listagem_agenda)

        expect(JSON.parse(result, symbolize_names: true)).to match(
          id: 3,
          nome: 'Equipamento Utilizável Y',
          fabricante: 'Fabricante Z',
          numero_serie: 'SN789',
          equipamento: {
            id: 2,
            nome: 'Equipamento X',
            codigo: 'EQ456',
            tipo_equipamento: {
              id: 1,
              nome: 'Tipo A',
              codigo: 'TE123'
            }
          },
          tipo_equipamento: {
            id: 1,
            nome: 'Tipo A',
            codigo: 'TE123'
          }
        )
      end
    end
  end
end
