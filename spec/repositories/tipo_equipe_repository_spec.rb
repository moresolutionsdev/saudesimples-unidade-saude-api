# frozen_string_literal: true

RSpec.describe TipoEquipeRepository do
  let!(:tipo_equipe1) { create(:tipo_equipe, sigla: 'EQP1', descricao: 'Equipe Teste 1') }
  let!(:tipo_equipe2) { create(:tipo_equipe, sigla: 'EQP2', descricao: 'Equipe Teste 2') }

  describe '.search' do
    context 'when no filters are applied' do
      it 'returns all tipo_equipes' do
        result = described_class.search

        expect(result).to include(tipo_equipe1, tipo_equipe2)
        expect(result.size).to eq(2)
      end
    end

    context 'when filtering by sigla' do
      it 'returns the filtered tipo_equipes' do
        result = described_class.search(sigla: 'EQP1')

        expect(result).to include(tipo_equipe1)
        expect(result).not_to include(tipo_equipe2)
        expect(result.size).to eq(1)
      end
    end

    context 'when filtering by descricao' do
      it 'returns the filtered tipo_equipes' do
        result = described_class.search(descricao: 'Equipe Teste 2')

        expect(result).to include(tipo_equipe2)
        expect(result).not_to include(tipo_equipe1)
        expect(result.size).to eq(1)
      end
    end

    context 'when filtering by sigla and descricao' do
      it 'returns the filtered tipo_equipes' do
        result = described_class.search(sigla: 'EQP1', descricao: 'Equipe Teste 1')

        expect(result).to include(tipo_equipe1)
        expect(result).not_to include(tipo_equipe2)
        expect(result.size).to eq(1)
      end
    end

    context 'when no results match the filters' do
      it 'returns an empty result' do
        result = described_class.search(sigla: 'NONEXISTENT')

        expect(result).to be_empty
      end
    end
  end
end
