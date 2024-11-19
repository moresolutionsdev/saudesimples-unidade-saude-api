# frozen_string_literal: true

RSpec.describe EquipeRepository, type: :model do
  describe '.list_from_cnes', :vcr do
    subject { described_class.list_from_cnes(page:) }

    context 'when fetching equipes with page' do
      let(:page) { 1 }

      it 'return equipes collection paginated' do
        expect(subject).not_to be_empty
      end

      it 'return default per_page' do
        expect(subject.size).to eq(25)
      end
    end

    context 'when fetching a page with no records' do
      let(:page) { 10 }

      it 'return empty collection' do
        expect(subject).to be_empty
      end
    end
  end

  describe '.search_minimal' do
    let!(:equipe1) { create(:equipe, nome: 'Equipe Alpha', codigo: 12_345) }
    let!(:equipe2) { create(:equipe, nome: 'Equipe Beta', codigo: 67_890) }
    let!(:equipe3) { create(:equipe, nome: 'Gamma', codigo: 11_111) }

    context 'when term is provided' do
      it 'returns equipes matching the term in the nome or codigo' do
        result = described_class.search_minimal(term: 'Equipe')

        expect(result).to contain_exactly(equipe1, equipe2)
      end

      it 'returns equipes matching the term in the codigo as a string' do
        result = described_class.search_minimal(term: '12345')

        expect(result).to contain_exactly(equipe1)
      end
    end

    context 'when term is not provided' do
      it 'returns all equipes ordered by nome' do
        result = described_class.search_minimal

        expect(result).to eq([equipe1, equipe2, equipe3])
      end
    end
  end
end
