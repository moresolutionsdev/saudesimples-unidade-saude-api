# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::PoliticasAcessoController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let!(:termo) { create(:termo_uso) }
    let(:params) { { page: 1, per_page: 10 } }

    before do
      get :index, params:
    end

    it 'returns a 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #ultima_versao' do
    include_context 'with an authenticated token'

    let!(:termo_uso) { create(:termo_uso, documento_tipo: 'politica_acesso', texto: 'Politica de acesso', versao: 2) }
    let!(:old_termo_uso) { create(:termo_uso, documento_tipo: 'politica_acesso', versao: 1) }

    context 'when the request is successful' do
      before do
        allow(PoliticasAcesso::UltimaVersaoService).to receive(:call).and_return(
          Success.new(termo_uso)
        )
        get :ultima_versao
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the latest version of Politica de acesso' do
        expected_response = {
          data: {
            id: termo_uso.id,
            documento_arquivo_url: termo_uso.documento_arquivo_url,
            titulo: termo_uso.titulo,
            texto: 'Politica de acesso',
            versao: termo_uso.versao,
            documento_tipo: termo_uso.documento_tipo,
            usuario: {
              id: termo_uso.usuario_id,
              email: termo_uso.usuario.email
            },
            created_at: termo_uso.created_at.strftime('%Y-%m-%d'),
            updated_at: termo_uso.updated_at.as_json
          }
        }
        expect(response.parsed_body).to eq(expected_response.as_json)
      end
    end
  end

  describe 'GET #show' do
    include_context 'with an authenticated token'

    let(:termo_uso) { create(:termo_uso, documento_tipo: 'politica_acesso') }

    before do
      allow(TermosUso::FindTermoUsoService).to receive(:call)
        .with(termo_uso.id.to_s)
        .and_return(success: termo_uso)
      get :show, params: { id: termo_uso.id }
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/unidade_saude/politicas_acesso' do
    include_context 'with an authenticated token'

    it 'cria uma nova politica de acesso e retorna status 200' do
      file = fixture_file_upload(
        Rails.root.join('spec/fixtures/files/teste_pdf.pdf'),
        'application/pdf'
      )

      post :create, params: { documento_arquivo: file }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['data']).to include(
        'titulo' => 'teste_pdf.pdf',
        'documento_tipo' => 'politica_acesso'
      )
    end
  end
end
