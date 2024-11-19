# frozen_string_literal: true

RSpec.describe Api::NacionalidadesController do
  describe 'GET /api/nacionalidades' do
    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        create(:nacionalidade, codigo: 1, nome: 'Brasileira')
      end

      it 'returns a success response' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns a serialized response' do
        get :index
        expect(response.parsed_body).to include(
          'data' => [
            a_hash_including(
              'id' => a_kind_of(Integer),
              'nome' => 'Brasileira',
              'codigo' => 1
            )
          ]
        )
      end
    end

    context 'when user is not authenticated' do
      include_context 'with a invalid token'

      it 'returns a unauthorized response' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
