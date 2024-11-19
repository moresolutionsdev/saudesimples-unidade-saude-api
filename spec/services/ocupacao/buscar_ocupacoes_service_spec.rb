# frozen_string_literal: true

RSpec.describe Ocupacao::BuscarOcupacoesService do
  describe '#call' do
    subject { described_class.call(params) }

    let!(:ocupacao) { create(:ocupacao) }

    let(:params) do
      {
        page: 1,
        per_page: 10,
        order: 'nome',
        direction: 'ASC'
      }
    end

    it 'returns a list of ocupacao' do
      expect(subject).to be_success
      expect(subject.data).to eq([ocupacao])
    end

    context 'with pagination' do
      before do
        create_list(:ocupacao, 5)
      end

      it 'returns the first page with 3 ocupacao' do
        params[:page] = 1
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end

      it 'returns the second page with 3 ocupacao' do
        params[:page] = 2
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end
    end
  end

  context 'when no filters are present' do
    subject { described_class.call(params) }

    let(:params) { {} }

    it 'returns all occupations' do
      create_list(:ocupacao, 5)

      expect(subject).to be_a(Success)
      expect(subject.data.count).to eq(5)
    end
  end

  context 'when filtering by name' do
    subject { described_class.call(params) }

    let(:search_name) { 'Ocupacao A' }
    let(:params) { { nome: search_name } }

    it 'returns occupations with matching names (ilike)' do
      create(:ocupacao, nome: 'Ocupacao A')
      create(:ocupacao, nome: 'Ocupacao B')
      create_list(:ocupacao, 3)

      expect(subject).to be_a(Success)
      expect(subject.data.pluck(:nome)).to include('Ocupacao A')
      expect(subject.data.count).to eq(1)
    end
  end

  context 'when filtering by search_term and order' do
    subject { described_class.call(params) }

    let(:params) do
      {
        search_term: 'OcupacaoA',
        order: 'codigo',
        order_direction: 'desc'
      }
    end

    it 'filters and orders occupations' do
      create(:ocupacao, codigo: 'SA123', nome: 'OcupacaoA')
      create(:ocupacao, codigo: 'ABC456', nome: 'OcupacaoB')
      create_list(:ocupacao, 3)

      expect(subject).to be_a(Success)
      expect(subject.data.first.codigo).to eq('SA123')
      expect(subject.data.count).to eq(1)
    end
  end
end
