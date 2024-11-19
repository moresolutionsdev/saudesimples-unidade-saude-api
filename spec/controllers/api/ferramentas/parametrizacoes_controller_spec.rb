# frozen_string_literal: true

RSpec.describe Api::Ferramentas::ParametrizacoesController do
  describe 'GET #index' do
    include_context 'with an authenticated token'
    context 'quando a chamada do serviço é bem-sucedida' do
      let(:parametrizacao) { double('Parametrizacao') }

      before do
        allow(Ferramentas::Parametrizacao::ListarService).to receive(:call).and_return(success: parametrizacao)
        allow(controller).to receive(:serialize).with(parametrizacao,
                                                      ParametrizacaoSerializer).and_return(parametrizacao)
      end

      it 'retorna status 200 e a serialização da parametrização' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(parametrizacao.to_json)
      end
    end

    context 'quando a chamada do serviço falha' do
      let(:error_message) { 'Erro ao listar' }

      before do
        allow(Ferramentas::Parametrizacao::ListarService).to receive(:call).and_return(failure: error_message)
      end

      it 'retorna status 422 e a mensagem de erro' do
        get :index
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error_message)
      end
    end
  end

  describe 'PUT #update' do
    include_context 'with an authenticated token'
    let(:parametrizacao) { double('Parametrizacao') }
    let(:valid_params) { { id: 1, logo_municipio: 'nova_logo.png' } }

    context 'quando a chamada do serviço é bem-sucedida' do
      before do
        allow(Ferramentas::Parametrizacao::UpdateService).to receive(:call)
          .with(hash_including(id: valid_params[:id].to_s,
                               logo_municipio: valid_params[:logo_municipio]))
          .and_return(success: parametrizacao)

        allow(controller).to receive(:serialize).with(parametrizacao,
                                                      ParametrizacaoSerializer).and_return(parametrizacao)
      end

      it 'retorna status 200 e a serialização da parametrização' do
        put :update, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(parametrizacao.to_json)
      end
    end

    context 'quando a chamada do serviço falha' do
      let(:error_message) { 'Erro ao atualizar' }

      before do
        allow(Ferramentas::Parametrizacao::UpdateService).to receive(:call)
          .with(hash_including(id: valid_params[:id].to_s,
                               logo_municipio: valid_params[:logo_municipio]))
          .and_return(failure: error_message)
      end

      it 'retorna status 422 e a mensagem de erro' do
        put :update, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error_message)
      end
    end
  end
end
