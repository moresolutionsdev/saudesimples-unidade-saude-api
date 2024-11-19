# frozen_string_literal: true

RSpec.describe Api::ProfissionaisController do
  describe 'GET #index' do
    let(:params) do
      {
        page: 1,
        per_page: 10,
        order: 'nome',
        direction: 'ASC'
      }
    end

    context 'when service call is successful' do
      let!(:profissional) { create(:profissional, name: 'Amanda') }
      let!(:other_profissional) { create(:profissional, name: 'Felix') }

      include_context 'with an authenticated token'
      it 'returns a 200 status code' do
        get(:index, params:)
        expect(response).to have_http_status(:ok)
      end

      it 'renders the correct json' do
        get(:index, params:)
        expect(response.parsed_body).to include(
          'data' => [
            {
              'codigo_cns' => profissional.codigo_cns,
              'id' => profissional.id,
              'nome' => profissional.nome,
              'cpf_numero' => profissional.cpf_numero,
              'matricula' => profissional.matricula
            },
            {
              'codigo_cns' => other_profissional.codigo_cns,
              'id' => other_profissional.id,
              'nome' => other_profissional.nome,
              'cpf_numero' => other_profissional.cpf_numero,
              'matricula' => other_profissional.matricula
            }
          ],
          'meta' => {
            'current_page' => '1',
            'total_pages' => 1,
            'total_count' => 2
          }
        )
      end
    end

    context 'when searching by nome' do
      let!(:profissional) { create(:profissional) }
      let(:search_params) do
        params.merge(nome: profissional.nome)
      end
      let!(:other_profissional) { create(:profissional) }

      include_context 'with an authenticated token'

      it 'returns a 200 status code' do
        get :index, params: search_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns only the records matching the search term' do
        get :index, params: search_params
        json_response = response.parsed_body
        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'].first['nome']).to eq(profissional.nome)
      end
    end

    context 'when service call fails' do
      let(:service_response) { double('ServiceResponse', success?: false, error: 'some error') }

      it 'returns a 401 status code' do
        get :index, params: { page: 1, nome: 'some_name' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders the error message' do
        get :index, params: { page: 1, nome: 'some_name' }
        expect(response.parsed_body).to eq('error' => 'Missing token')
      end
    end

    context 'when paginating results' do
      include_context 'with an authenticated token'

      before do
        create(:profissional, nome: 'Engineer')
        create(:profissional, nome: 'Doctor')
        create(:profissional, nome: 'Teacher')
        create(:profissional, nome: 'Nurse')
      end

      let(:pagination_params) do
        {
          page: 2,
          per_page: 2,
          order: 'nome',
          direction: 'ASC'
        }
      end

      it 'returns a 200 status code' do
        get :index, params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct paginated records' do
        get :index, params: pagination_params
        json_response = response.parsed_body

        expect(json_response['data'].length).to eq(2)
        expect(json_response['data'].first['nome']).to eq('Nurse')
        expect(json_response['data'].second['nome']).to eq('Teacher')
        expect(json_response['meta']['current_page']).to eq('2')
        expect(json_response['meta']['total_pages']).to eq(2)
        expect(json_response['meta']['total_count']).to eq(4)
      end
    end
  end
end
