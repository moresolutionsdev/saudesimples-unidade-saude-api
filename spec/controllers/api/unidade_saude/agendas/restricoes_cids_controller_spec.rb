# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UnidadeSaude::Agendas::RestricoesCidsController do
  include_context 'with an authenticated token'

  let(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
  let!(:agenda) { create(:agenda, unidade_saude_ocupacao:) }
  let!(:cid) { create(:cid) }
  let!(:restricao_cid) { create(:agenda_restricao_cid, codigo_cid: cid.codigo, agenda:) }

  let(:params) do
    {
      id: agenda.id
    }
  end

  # Corrige as chaves para strings
  let(:serialized_data) do
    {
      'id' => restricao_cid.id,
      'cid' => {
        'id' => restricao_cid.id,
        'co_cid' => restricao_cid.codigo_cid,
        'no_cid' => cid.nome
      }
    }
  end

  describe 'GET #index' do
    context 'when the request is successful' do
      before do
        get :index, params:
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the list of restrictions' do
        expect(response.parsed_body).to include(
          'data' => [serialized_data],
          'meta' => { 'current_page' => 1, 'total_pages' => 1, 'total_count' => 1 }
        )
      end
    end

    context 'when there are no restrictions' do
      before do
        AgendaRestricaoCid.destroy_all
        get :index, params:
      end

      it 'returns status code 200 with empty data' do
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include(
          'data' => [],
          'meta' => { 'current_page' => 1, 'total_pages' => 0, 'total_count' => 0 }
        )
      end
    end

    context 'when the agenda does not exist' do
      before do
        get :index, params: { id: 9999 }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(response.parsed_body[:message]).to include("Couldn't find Agenda with 'id'=9999")
      end
    end
  end

  describe 'pagination and filtering' do
    let!(:restricoes_extra) { create_list(:agenda_restricao_cid, 5, agenda:) }

    context 'when paginating' do
      let(:params) { { page: 1, per_page: 3, id: agenda.id } }

      before { get :index, params: }

      it 'returns paginated data' do
        expect(response.parsed_body['data'].size).to eq(3)
        expect(response.parsed_body['meta']['total_count']).to eq(6)
      end
    end
  end
end
