# frozen_string_literal: true

RSpec.describe Profissional::BuscarProfissionaisService do
  describe '#call' do
    subject { described_class.call(params) }

    let!(:profissional) { create(:profissional) }

    let(:params) do
      {
        page: 1,
        per_page: 10,
        order: 'nome',
        direction: 'ASC'
      }
    end

    it 'returns a list of profissional' do
      expect(subject).to be_success
      expect(subject.data).to eq([profissional])
    end

    context 'with pagination' do
      before do
        create_list(:profissional, 5)
      end

      it 'returns the first page with 3 profissional' do
        params[:page] = 1
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end

      it 'returns the second page with 3 profissional' do
        params[:page] = 2
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end
    end
  end
end
