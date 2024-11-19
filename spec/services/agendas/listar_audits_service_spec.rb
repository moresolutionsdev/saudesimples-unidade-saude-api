# frozen_string_literal: true

RSpec.describe Agendas::ListarAuditsService, type: :service do
  let!(:agenda) { create(:agenda) }
  let!(:audits) { create_list(:audit, 5, auditable: agenda) }

  describe '#call' do
    context 'when there are audits for the agenda' do
      subject { described_class.new(agenda.id, params).call }

      let(:params) { { page: 1, per_page: 5, order: 'created_at', order_direction: 'desc' } }

      it 'returns success true' do
        expect(subject[:success]).to be(true)
      end

      it 'returns the correct number of audits' do
        expect(subject[:data].size).to eq(5)
      end

      it 'returns audits in descending order by created_at' do
        expect(subject[:data].first.created_at).to be >= subject[:data].last.created_at
      end
    end

    context 'when no audits are found for the agenda' do
      subject { described_class.new(agenda.id, params).call }

      before do
        agenda.audits.delete_all
      end

      let(:params) { { page: 1, per_page: 5 } }

      it 'returns success true' do
        expect(subject[:success]).to be(true)
      end

      it 'returns an empty array for data' do
        expect(subject[:data]).to be_empty
      end
    end

    context 'when the agenda does not exist' do
      subject { described_class.new(9999, params).call }

      let(:params) { { page: 1, per_page: 5 } }

      it 'returns success false' do
        expect(subject[:success]).to be(false)
      end

      it 'returns the correct error message' do
        expect(subject[:error]).to include("Couldn't find Agenda with 'id'=9999")
      end
    end

    context 'when order direction is different' do
      subject { described_class.new(agenda.id, params).call }

      let(:params) { { page: 1, per_page: 5, order: 'created_at', order_direction: 'asc' } }

      it 'returns audits in ascending order by created_at' do
        expect(subject[:data].first.created_at).to be <= subject[:data].last.created_at
      end
    end
  end
end
