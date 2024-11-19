# frozen_string_literal: true

RSpec.describe Equipes::ListEquipesService, type: :service do
  describe '#call' do
    let(:params) { { term: 'Equipe Teste' } }
    let(:equipes) { [create(:equipe, nome: 'Equipe Teste', codigo: 12_345)] }

    context 'when the service succeeds' do
      it 'returns a successful result with equipes' do
        allow(EquipeRepository).to receive(:search_minimal).with(params).and_return(equipes)

        result = described_class.new(params).call

        expect(result).to be_success
        expect(result.data).to eq(equipes)
      end
    end

    context 'when the service fails' do
      it 'returns a failure result with an error message' do
        allow(EquipeRepository).to receive(:search_minimal).and_raise(StandardError.new('Some error'))

        result = described_class.new(params).call

        expect(result).to be_failure
        expect(result.error).to eq('Erro ao listar Equipes')
      end
    end
  end
end
