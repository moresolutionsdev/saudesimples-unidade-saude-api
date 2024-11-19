# frozen_string_literal: true

RSpec.describe Api::UnidadeSaudeOcupacoesController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
    let(:unidade_saude_id) { unidade_saude_ocupacao.unidade_saude_id }
    let(:serialized_ocupacoes) do
      UnidadeSaudeOcupacaoSerializer.render_as_hash(unidade_saude_ocupacao, view: :listagem_agenda)
    end

    context 'quando unidade saude tem ocupacoes' do
      before do
        get :index, params: { unidade_saude_id: }
      end

      it 'render 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'serialize ocupacoes' do
        expect(response.parsed_body['data']).to include(serialized_ocupacoes)
      end
    end

    context 'quando algum erro acontece' do
      let(:failure) { Failure.new('something') }
      let(:service) { instance_double(UnidadeSaudeOcupacoes::ListarOcupacoesService) }

      before do
        allow(UnidadeSaudeOcupacoes::ListarOcupacoesService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(failure)

        get :index, params: { unidade_saude_id: }
      end

      it 'render 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
