# frozen_string_literal: true

RSpec.describe TipoEquipes::ListTipoEquipesService do
  describe '#call' do
    let!(:tipo_equipe1) { create(:tipo_equipe, sigla: 'EQP1', descricao: 'Equipe Teste 1') }
    let!(:tipo_equipe2) { create(:tipo_equipe, sigla: 'EQP2', descricao: 'Equipe Teste 2') }

    context 'when no filters are applied' do
      it 'returns all tipo_equipes' do
        result = described_class.call({})

        expect(result).to be_success
        expect(result.data.size).to eq(2)
        expect(result.data).to include(tipo_equipe1, tipo_equipe2)
      end
    end

    context 'when filtering by sigla' do
      it 'returns the filtered tipo_equipes' do
        result = described_class.call({ sigla: 'EQP1' })

        expect(result).to be_success
        expect(result.data.size).to eq(1)
        expect(result.data.first).to eq(tipo_equipe1)
      end
    end

    context 'when filtering by descricao' do
      it 'returns the filtered tipo_equipes' do
        result = described_class.call({ descricao: 'Equipe Teste 2' })

        expect(result).to be_success
        expect(result.data.size).to eq(1)
        expect(result.data.first).to eq(tipo_equipe2)
      end
    end

    context 'when pagination is applied' do
      it 'returns paginated results' do
        result = described_class.call({ page: 1, per_page: 1 })

        expect(result).to be_success
        expect(result.data.size).to eq(1)
        expect(result.data.first).to eq(tipo_equipe1)
      end
    end

    context 'when an error occurs' do
      before do
        allow(TipoEquipeRepository).to receive(:search).and_raise(StandardError, 'Database error')
      end

      it 'returns a failure' do
        result = described_class.call({})

        expect(result).to be_failure
        expect(result.error).to eq('Erro ao listar Tipo de Equipes')
      end
    end
  end
end
