# frozen_string_literal: true

RSpec.describe Endereco::Paises::ListarService do
  describe '#call' do
    subject { described_class.call(index_params) }

    let(:index_params) { { page: 1, per_page: 2, search_term: } }
    let(:search_term) { nil }

    before do
      create_list(:pais, 5)
    end

    context 'when search_term is blank' do
      let(:search_term) { '' }

      it 'renders a paginated collection' do
        expect(subject.data.size).to eq(2)
      end

      it 'returns a success object' do
        expect(subject).to be_a(Success)
      end
    end

    context 'when search_term is present' do
      let(:search_term) { 'ar' }

      before do
        create(:pais, nome: 'eua')
        create(:pais, nome: 'china')
        create(:pais, nome: 'argentina')
        create(:pais, nome: 'albania')
        create(:pais, nome: 'armenia')
      end

      it 'renders a filtered collection' do
        expect(subject.data.size).to eq(2)
        expect(subject.data.first.nome).to eq('argentina')
        expect(subject.data.second.nome).to eq('armenia')
      end

      it 'returns a success object' do
        expect(subject).to be_a(Success)
      end
    end
  end
end
