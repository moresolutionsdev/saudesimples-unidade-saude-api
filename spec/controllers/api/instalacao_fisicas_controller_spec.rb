# frozen_string_literal: true

RSpec.describe Api::InstalacaoFisicasController do
  describe 'GET #search' do
    include_context 'with an authenticated token'
    let!(:instalacao_fisica) { create(:instalacao_fisica, nome: 'Instalacao 1', codigo: 'I1') }

    context 'when searching by id' do
      it 'returns the record' do
        get :search, params: { id: instalacao_fisica.id }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include(
          'data' => [
            a_hash_including(
              'id' => instalacao_fisica.id
            )
          ]
        )
      end
    end

    context 'when searching by name' do
      it 'returns the record' do
        get :search, params: { nome: instalacao_fisica.nome }
        expect(response).to have_http_status(:ok)
        response.parsed_body
        expect(response.parsed_body).to include(
          'data' => [
            a_hash_including(
              'nome' => instalacao_fisica.nome
            )
          ]
        )
      end
    end

    context 'when no record is found' do
      it 'returns empty data' do
        get :search, params: { nome: 'Nonexistent' }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include('data' => [])
      end
    end
  end
end
