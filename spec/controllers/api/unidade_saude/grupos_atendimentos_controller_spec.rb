# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::GruposAtendimentosController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:valid_params) { { profissional_id: '1', search_term: 'teste', unidade_saude_id: '1' } }
    let(:result) { double('GrupoAtendimentoResult') }

    context 'when the service call is successful' do
      before do
        get :index, params: valid_params
      end

      it 'returns a 200 status and serialized data' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the service call fails' do
      let(:error_message) { 'Error message' }

      before do
        allow(UnidadeSaude::GrupoAtendimentoService).to receive(:call)
          .with(ActionController::Parameters.new(valid_params).permit!)
          .and_return(failure: error_message)

        get :index, params: valid_params
      end

      it 'returns a 422 status and an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error_message)
      end
    end
  end
end
