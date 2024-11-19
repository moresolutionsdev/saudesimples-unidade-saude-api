# frozen_string_literal: true

RSpec.describe GrupoAtendimentoRepository do
  let!(:grupo_1) { create(:grupo_atendimento, nome: 'Grupo A') }
  let!(:grupo_2) { create(:grupo_atendimento, nome: 'Grupo B') }
  let!(:grupo_3) { create(:grupo_atendimento, nome: 'Teste C') }

  describe '.filter' do
    context 'when no filters are provided' do
      it 'returns all records' do
        result = described_class.filter({})
        expect(result).to contain_exactly(grupo_1, grupo_2, grupo_3)
      end
    end

    context 'when filtering by search_term' do
      it 'returns records that match the search_term' do
        result = described_class.filter(search_term: 'Grupo')
        expect(result).to contain_exactly(grupo_1, grupo_2)
      end

      it 'is case-insensitive when filtering by search_term' do
        result = described_class.filter(search_term: 'grupo')
        expect(result).to contain_exactly(grupo_1, grupo_2)
      end
    end
  end
end
