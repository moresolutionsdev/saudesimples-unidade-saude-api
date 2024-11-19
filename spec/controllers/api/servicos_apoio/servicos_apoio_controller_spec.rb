# frozen_string_literal: true

RSpec.describe Api::ServicosApoio::ServicosApoioController do
  describe 'GET /api/unidade_saude/:unidade_saude_id/servicos_apoio' do
    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }
    let!(:servico_apoio) { create(:servico_apoio, unidade_saude:, caracteristica_servico:, tipo_servico_apoio:) }

    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        page: 1,
        per_page: 10,
        order: 'tipo_servico',
        direction: 'ASC'
      }
    end

    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      it 'returns a success response' do
        get(:index, params:)
        expect(response).to have_http_status(:success)
      end

      it 'returns a serialized response' do
        get(:index, params:)

        expect(response.parsed_body).to include(
          'data' => [
            a_hash_including(
              'id' => a_kind_of(Integer),
              'tipo_servico_apoio' => {
                'id' => servico_apoio.tipo_servico_apoio.id,
                'nome' => servico_apoio.tipo_servico_apoio.nome,
                'codigo' => servico_apoio.tipo_servico_apoio.codigo
              },
              'caracteristica_servico' => {
                'id' => caracteristica_servico.id,
                'nome' => caracteristica_servico.nome,
                'codigo' => caracteristica_servico.codigo
              },
              'actions' => a_kind_of(Hash)
            )
          ],
          'meta' => a_kind_of(Hash)
        )
      end
    end

    context 'when user is not authenticated' do
      include_context 'with a invalid token'

      it 'returns a unauthorized response' do
        get(:index, params:)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/unidade_saude/:unidade_saude_id/servicos_apoio' do
    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }

    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        tipo_servico_apoio_id: tipo_servico_apoio.id,
        caracteristica_servico_id: caracteristica_servico.id
      }
    end

    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        allow(AuthorizationService).to receive(:new).and_return(
          double(permissions: { servicos_apoio: { create: true } })
        )
      end

      it 'returns a created response' do
        post(:create, params:)

        expect(response).to have_http_status(:created)
      end

      it 'returns a serialized response' do
        post(:create, params:)

        expect(response.parsed_body).to include(
          'data' => a_hash_including(
            'id' => a_kind_of(Integer),
            'tipo_servico_apoio' => {
              'id' => tipo_servico_apoio.id,
              'nome' => tipo_servico_apoio.nome,
              'codigo' => tipo_servico_apoio.codigo
            },
            'caracteristica_servico' => {
              'id' => caracteristica_servico.id,
              'nome' => caracteristica_servico.nome,
              'codigo' => caracteristica_servico.codigo
            },
            'actions' => a_kind_of(Hash)
          )
        )
      end

      context 'when service creation fails' do
        let(:caracteristica_servico) { create(:caracteristica_servico, id: 1) }
        let(:tipo_servico_apoio) { create(:tipo_servico_apoio, id: 1) }
        let(:params) do
          {
            unidade_saude_id: unidade_saude.id,
            tipo_servico_apoio_id: 1,
            caracteristica_servico_id: 1
          }
        end

        before do
          create(:servico_apoio, unidade_saude:, caracteristica_servico:, tipo_servico_apoio:)

          post(:create, params:)
        end

        it 'return 400 status code' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'return error message' do
          expect(response.parsed_body).to eq(
            {
              'code' => 400,
              'message' => {
                'unidade_saude_id' => [
                  'Tipo de serviço já inserido, caso deseje modificar remova e adicione novamente.'
                ]
              },
              'status' => 'bad_request'
            }
          )
        end
      end

      context 'when user is not authorized' do
        before do
          allow(AuthorizationService).to receive(:new).and_return(
            double(permissions: { servicos_apoio: { create: false } })
          )
        end

        it 'returns a forbidden response' do
          post(:create, params:)
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when user is not authenticated' do
        include_context 'with a invalid token'

        it 'returns a unauthorized response' do
          post(:create, params:)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE /api/unidade_saude/:unidade_saude_id/servicos_apoio/:id' do
    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }
    let!(:servico_apoio) { create(:servico_apoio, unidade_saude:, caracteristica_servico:, tipo_servico_apoio:) }

    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        id: servico_apoio.id
      }
    end

    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        allow(AuthorizationService).to receive(:new).and_return(
          double(permissions: { servicos_apoio: { delete: true } })
        )
      end

      it 'returns a no content response' do
        delete(:destroy, params:)
        expect(response).to have_http_status(:no_content)
      end

      context 'when user is not authorized' do
        before do
          allow(AuthorizationService).to receive(:new).and_return(
            double(permissions: { servicos_apoio: { delete: false } })
          )
        end

        it 'returns a forbidden response' do
          delete(:destroy, params:)
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when user is not authenticated' do
        include_context 'with a invalid token'

        it 'returns a unauthorized response' do
          delete(:destroy, params:)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
