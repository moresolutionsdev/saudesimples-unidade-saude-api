# frozen_string_literal: true

RSpec.describe Api::AreasController do
  include_context 'with an authenticated token'

  let!(:areas) { create_list(:area, 10) }

  describe 'GET #index' do
    context 'when no parameters are provided' do
      before { get :index }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all areas' do
        expect(json_response['data'].size).to eq(10)
      end

      it 'includes pagination info' do
        expect(json_response['meta']).to include(
          'current_page' => 1,
          'total_pages' => 1,
          'total_count' => 10
        )
      end
    end

    context 'when paginating with parameters' do
      before { get :index, params: { page: 2, per_page: 5 } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct number of areas for the page' do
        expect(json_response['data'].size).to eq(5)
      end

      it 'includes correct pagination info' do
        expect(json_response['meta']).to include(
          'current_page' => 2,
          'total_pages' => 2,
          'total_count' => 10
        )
      end
    end

    context 'when filtering by nome' do
      before { get :index, params: { nome: areas.first.nome } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when sorting by nome' do
      before { get :index, params: { order: 'nome', order_direction: 'asc' } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns areas sorted by nome in ascending order' do
        sorted_names = areas.sort_by(&:nome).map(&:nome)
        response_names = json_response['data'].pluck('nome')
        expect(response_names).to eq(sorted_names)
      end
    end
  end

  def json_response
    @json_response ||= response.parsed_body
  end
end
