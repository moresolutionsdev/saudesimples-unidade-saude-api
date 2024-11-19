# frozen_string_literal: true

RSpec.describe Api::ServicosApoio::CaracteristicasServicosController do
  describe 'GET /api/unidade_saude/servicos_apoio/caracteristica' do
    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        create(:caracteristica_servico, codigo: 'S', nome: 'Característica Serviço 1')
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
              'nome' => 'Característica Serviço 1',
              'codigo' => 'S'
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
