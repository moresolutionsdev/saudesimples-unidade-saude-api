# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::AgendaAuditsController do
  include_context 'with an authenticated token'
  let!(:agenda) { create(:agenda) }
  let!(:audits) { create_list(:audit, 5, auditable: agenda) }

  before do
    agenda.update(inativo: true)
    create(:audit, auditable: agenda)
  end

  describe 'GET #index' do
    context 'when audits are present' do
      before do
        get :index, params: { agenda_id: agenda.id, page: 1, per_page: 5 }
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct number of audits' do
        parsed_body = response.parsed_body
        expect(parsed_body['data'].size).to eq(5)
      end

      it 'returns correct audit fields' do
        parsed_body = response.parsed_body['data'].first
        expect(parsed_body).to have_key('id')
        expect(parsed_body).to have_key('action')
        expect(parsed_body).to have_key('auditable_id')
        expect(parsed_body).to have_key('auditable_type')
        expect(parsed_body).to have_key('created_at')
        expect(parsed_body).to have_key('remote_address')
      end
    end

    context 'when no audits are found' do
      before do
        agenda.audits.delete_all
        get :index, params: { agenda_id: agenda.id, page: 1, per_page: 5 }
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns empty data array' do
        parsed_body = response.parsed_body
        expect(parsed_body['data']).to be_empty
      end

      it 'does not return incorrect audit fields' do
        parsed_body = response.parsed_body['data']
        expect(parsed_body).not_to include('id')
        expect(parsed_body).not_to include('action')
      end
    end

    context 'when the agenda does not exist' do
      before do
        get :index, params: { agenda_id: 9999, page: 1, per_page: 5 }
      end

      it 'returns status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
