# frozen_string_literal: true

RSpec.describe Api::MicroAreasController do
  include_context 'with an authenticated token'

  let!(:micro_areas) do
    [
      create(:micro_area, codigo: 11, nome: 'Area 1'),
      create(:micro_area, codigo: 22, nome: 'Area 2'),
      create(:micro_area, codigo: 33, nome: 'Area 3')
    ]
  end

  describe 'GET #index' do
    context 'when no parameters are provided' do
      before { get :index }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all micro_areas' do
        expect(json_response['data'].size).to eq(3)
      end

      it 'includes pagination info' do
        expect(json_response['meta']).to include(
          'current_page' => 1,
          'total_pages' => 1,
          'total_count' => 3
        )
      end
    end

    context 'when paginating with parameters' do
      before { get :index, params: { page: 2, per_page: 2 } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct number of micro_areas for the page' do
        expect(json_response['data'].size).to eq(1) # Only one item on the second page
      end

      it 'includes correct pagination info' do
        expect(json_response['meta']).to include(
          'current_page' => 2,
          'total_pages' => 2,
          'total_count' => 3
        )
      end
    end

    context 'when filtering by nome' do
      before { get :index, params: { nome: micro_areas.first.nome } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct micro_area' do
        expect(json_response['data'].size).to eq(1)
        expect(json_response['data'].first['nome']).to eq(micro_areas.first.nome)
      end
    end

    context 'when filtering by codigo' do
      before { get :index, params: { codigo: 22 } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct micro_area' do
        expect(json_response['data'].size).to eq(1)
        expect(json_response['data'].first['codigo']).to eq(22)
      end
    end

    context 'when filtering by area_id' do
      before { get :index, params: { area_id: micro_areas.first.area_id } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct micro_areas' do
        area_id = micro_areas.first.area_id
        expect(json_response['data'].all? { |d| d['area_id'] == area_id }).to be true
      end
    end

    context 'when sorting by nome' do
      before { get :index, params: { order: 'nome', order_direction: 'asc' } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns micro_areas sorted by nome in ascending order' do
        sorted_names = micro_areas.sort_by(&:nome).map(&:nome)
        response_names = json_response['data'].pluck('nome')
        expect(response_names).to eq(sorted_names)
      end
    end

    context 'when sorting by nome in descending order' do
      before { get :index, params: { order: 'nome', order_direction: 'desc' } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns micro_areas sorted by nome in descending order' do
        sorted_names = micro_areas.sort_by(&:nome).map(&:nome).reverse
        response_names = json_response['data'].pluck('nome')
        expect(response_names).to eq(sorted_names)
      end
    end
  end

  def json_response
    @json_response ||= response.parsed_body
  end
end
