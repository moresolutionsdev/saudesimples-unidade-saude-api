# frozen_string_literal: true

RSpec.describe Api::ServicosApoio::TiposController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    describe 'deve retornar uma lista de tipos de serviço de apoio por nome' do
      let(:nome_servico) { 'Tipo Serviço Apoio 1' }
      let(:params) { { nome: nome_servico } }

      before do
        create(:tipo_servico_apoio)
        get :index, params:
      end

      it 'retorna http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'deve retornar o nome correto do primeiro serviço' do
        expect(response.parsed_body['data'].first['nome']).to eq(nome_servico)
      end
    end
  end
end
