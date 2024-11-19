# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnidadeSaude::Agendas::ListarRestricoesPorCidService, type: :service do
  let(:agenda) { create(:agenda) }
  let!(:restricoes) { create_list(:agenda_restricao_cid, 5, agenda:) }

  describe '#call' do
    context 'when the agenda exists' do
      it 'returns a success response with paginated restricoes' do
        service = described_class.new(agenda.id, page: 1, per_page: 3, order: 'created_at', order_direction: 'asc')
        result = service.call

        expect(result[:success]).to be(true)
        expect(result[:data].size).to eq(3)
        expect(result[:current_page]).to eq(1)
        expect(result[:total_pages]).to eq(2)
        expect(result[:total_count]).to eq(5)
      end

      it 'returns the data ordered by the specified column and direction' do
        service = described_class.new(agenda.id, page: 1, per_page: 5, order: 'created_at', order_direction: 'desc')
        result = service.call

        expect(result[:data].first.created_at).to be > result[:data].last.created_at
      end
    end

    context 'when the agenda does not exist' do
      it 'returns a failure response with an error message' do
        service = described_class.new(9999)
        result = service.call

        expect(result[:success]).to be(false)
        expect(result[:error]).to eq("Couldn't find Agenda with 'id'=9999 [WHERE \"agendas\".\"deleted_at\" IS NULL]")
      end
    end

    context 'when there are no restrictions for the agenda' do
      before do
        AgendaRestricaoCid.destroy_all
      end

      it 'returns an empty data set with correct pagination metadata' do
        service = described_class.new(agenda.id)
        result = service.call

        expect(result[:success]).to be(true)
        expect(result[:data].size).to eq(0)
        expect(result[:current_page]).to eq(1)
        expect(result[:total_pages]).to eq(0)
        expect(result[:total_count]).to eq(0)
      end
    end
  end
end
