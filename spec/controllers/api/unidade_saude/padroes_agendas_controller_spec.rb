# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::PadroesAgendasController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    before do
      create_list(:padrao_agenda, 3)

      get :index
    end

    it 'return collection' do
      expect(response.parsed_body['data'].size).to eq(3)
    end

    it 'return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    context 'when failure' do
      before do
        allow(PadraoAgenda).to receive(:all).and_raise(StandardError)

        get :index
      end

      it 'return error message' do
        expect(response.parsed_body['message']).to eq('Erro ao listar padrões de agenda')
      end

      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
