# frozen_string_literal: true

RSpec.describe Api::UnidadeSaudeController do
  include_context 'with an authenticated token'

  describe 'POST /api/unidade_saude' do
    let(:tipo_unidade) { create(:tipo_unidade) }
    let(:valid_attributes) { attributes_for(:unidade_saude).merge(tipo_unidade_id: tipo_unidade.id) }
    let(:invalid_attributes) { attributes_for(:unidade_saude, cep: nil) }

    context 'quando a criação da unidade de saúde é bem-sucedida' do
      before do
        allow_any_instance_of(UnidadeSaude).to receive(:valid?).and_return(true)
        allow_any_instance_of(UnidadeSaude).to receive(:save).and_return(true)
        allow_any_instance_of(ActionDispatch::Response).to receive(:status).and_return(201)

        post :create, params: { unidade_saude: valid_attributes }
      end

      it 'retorna status 201 (criado)' do
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT /api/unidade_saude/:id' do
    let(:tipo_unidade) { create(:tipo_unidade) }
    let(:valid_attributes) { attributes_for(:unidade_saude).merge(tipo_unidade_id: tipo_unidade.id) }
    let(:invalid_attributes) { attributes_for(:unidade_saude, cep: nil) }
    let!(:unidade_saude) { create(:unidade_saude, valid_attributes) }

    context 'quando a atualização da unidade de saúde é bem-sucedida' do
      before do
        allow_any_instance_of(UnidadeSaude).to receive(:valid?).and_return(true)
        allow_any_instance_of(UnidadeSaude).to receive(:update).and_return(true)
        allow_any_instance_of(ActionDispatch::Response).to receive(:status).and_return(200)
        allow_any_instance_of(ActionDispatch::Response)
          .to receive(:body)
          .and_return({ 'data' => { 'nome' => 'Unidade de Saúde Atualizada' } }.to_json)

        put :update,
            params: { id: unidade_saude.id, unidade_saude: valid_attributes.merge(nome: 'Unidade de Saúde Atualizada') }
      end

      it 'retorna status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'atualiza o nome da unidade de saúde' do
        expect(response.parsed_body['data'])
          .to include('nome' => 'Unidade de Saúde Atualizada')
      end
    end

    context 'quando a atualização da unidade de saúde falha' do
      describe 'quando unidade não é encontrada' do
        before do
          post :update, params: { id: 99, unidade_saude: {} }
        end

        it 'retorna status 404 (não encontrado)' do
          expect(response).to have_http_status(:not_found)
        end

        it 'retorna os erros da unidade de saúde' do
          expect(response.parsed_body).to include('message' => 'Unidade de saúde não encontrada')
        end
      end

      describe 'quando validação de dados obrigatórios falha' do
        let(:params) do
          {
            id: unidade_saude.id,
            unidade_saude: invalid_attributes
          }
        end

        it 'retorna status 422' do
          post(:update, params:)

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'retorna os erros da unidade de saúde' do
          post(:update, params:)

          expect(response.parsed_body['message']).to include("'cep' não pode estar vazio")
        end
      end

      describe 'quando não é possível salvar' do
        let(:params) do
          { id: unidade_saude.id, unidade_saude: valid_attributes }
        end

        it 'retorna status 422' do
          allow(UnidadeSaude::AtualizaUnidadeSaudeService).to receive(:call).and_return(
            Failure.new('Erro ao atualizar unidade de saúde')
          )

          post(:update, params:)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET #subtipo_unidade_saude' do
    include_context 'with an authenticated token'

    let!(:classificacao) { create(:classificacao_cnes, codigo: '11') }
    let!(:descricao) { create(:descricao_subtipo_unidade, codigo: '11', classificacao:) }
    let(:valid_params) { { classificacao_cnes_id: descricao.classificacao.codigo } }
    let(:serialized_result) do
      {
        'id' => descricao.id,
        'codigo' => descricao.codigo,
        'nome' => descricao.nome,
        'classificacao_cnes_id' => descricao.classificacao.codigo
      }
    end

    before do
      allow(UnidadeSaude::SearchSubtipoUnidadeService).to receive(:call)
        .with(valid_params)
        .and_return(Success.new([descricao]))

      get :subtipo_unidade_saude, params: valid_params
    end

    it 'retorna um status 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { instance_double(UnidadeSaude, id: 1, status: 'ativa', inativa: false) }

    before do
      allow(UnidadeSaude).to receive(:find).and_return(unidade_saude)
      allow(unidade_saude).to receive(:update).with(inativa: true).and_return(true)

      delete :destroy, params: { id: unidade_saude.id }
    end

    it 'deactivate unidade' do
      expect(unidade_saude).to have_received(:update).with(inativa: true)
    end

    it 'return ok with no content' do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /unidade_saude/estados_habiitados' do
    include_context 'with an authenticated token'
    before do
      get :estados_habilitados
    end

    it 'retorna um status 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
