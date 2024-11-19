# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::InstalacaoFisica::InstalacaoUnidadesController do
  describe 'POST #create' do
    include_context 'with an authenticated token'
    let(:instalacao_fisica_attributes) do
      {
        instalacao_fisica_id: 1,
        qtde_instalacoes: 10,
        qtde_leitos: 50
      }
    end

    let(:instalacao_fisica) do
      create(:instalacao_fisica,
             id: 1,
             codigo: 'I1',
             nome: 'Instalacao 1',
             subtipo_instalacao: create(:subtipo_instalacao, id: 2, codigo: 'S1', nome: 'Subtipo 1'),
             tipo_instalacao_fisica: create(:tipo_instalacao_fisica, id: 4, codigo: 'T1', nome: 'Tipo 1'))
    end

    let(:valid_attributes) do
      instalacao_fisica_attributes
    end

    context 'when creating a new instalacao_unidade_saude' do
      it 'creates a new instalacao_unidade_saude' do
        unidade_saude = create(:unidade_saude, id: 88)

        allow(InstalacaoFisica).to receive(:find)
          .with(instalacao_fisica_attributes[:instalacao_fisica_id].to_s)
          .and_return(instalacao_fisica)

        expect do
          post :create, params: { id: unidade_saude.id }.merge(valid_attributes)
        end.to change(InstalacaoUnidadeSaude, :count).by(1)
      end
    end

    context 'when returning a success response' do
      it 'returns a success response' do
        unidade_saude = create(:unidade_saude, id: 88)

        allow(InstalacaoFisica).to receive(:find)
          .with(instalacao_fisica_attributes[:instalacao_fisica_id].to_s)
          .and_return(instalacao_fisica)

        post :create, params: { id: unidade_saude.id }.merge(valid_attributes)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when returning the created instalacao_unidade_saude as JSON' do
      it 'returns the created instalacao_unidade_saude as JSON' do
        unidade_saude = create(:unidade_saude, id: 88)

        allow(InstalacaoFisica).to receive(:find)
          .with(instalacao_fisica_attributes[:instalacao_fisica_id].to_s)
          .and_return(instalacao_fisica)

        post :create, params: { id: unidade_saude.id }.merge(valid_attributes)

        expect(response.parsed_body['data']).to include(
          'id' => be_a(Integer),
          'instalacao_fisica' => a_hash_including(
            'id' => instalacao_fisica.id,
            'codigo' => instalacao_fisica.codigo,
            'nome' => instalacao_fisica.nome,
            'subtipo_instalacao' => a_hash_including(
              'id' => instalacao_fisica.subtipo_instalacao.id,
              'codigo' => instalacao_fisica.subtipo_instalacao.codigo,
              'nome' => instalacao_fisica.subtipo_instalacao.nome
            ),
            'tipo_instalacao_fisica' => a_hash_including(
              'id' => instalacao_fisica.tipo_instalacao_fisica.id,
              'codigo' => instalacao_fisica.tipo_instalacao_fisica.codigo,
              'nome' => instalacao_fisica.tipo_instalacao_fisica.nome
            )
          ),
          'qtde_instalacoes' => instalacao_fisica_attributes[:qtde_instalacoes],
          'qtde_leitos' => instalacao_fisica_attributes[:qtde_leitos],
          'unidade_saude_id' => unidade_saude.id
        )
      end
    end
  end

  describe 'GET #index' do
    let(:unidade_saude) { create(:unidade_saude, id: 88) }

    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        allow(AuthorizationService).to receive(:new).and_return(
          double(permissions: { instalacao_fisica: { delete: true } })
        )
      end

      it 'returns a success response' do
        get :index, params: { unidade_saude_id: unidade_saude.id }
        expect(response).to have_http_status(:success)
      end

      it 'returns a serialized response' do
        instalacao_fisica = create(:instalacao_fisica,
                                   id: 13,
                                   codigo: 'I3',
                                   nome: 'Instalacao 3',
                                   subtipo_instalacao: create(:subtipo_instalacao, id: 2, codigo: 'S1',
                                                                                   nome: 'Subtipo 1'),
                                   tipo_instalacao_fisica: create(:tipo_instalacao_fisica, id: 4, codigo: 'T1',
                                                                                           nome: 'Tipo 1'))

        create(:instalacao_unidade_saude, id: 29, unidade_saude:, instalacao_fisica:,
                                          qtde_instalacoes: 2, qtde_leitos: 5)

        get :index,
            params: { unidade_saude_id: unidade_saude.id, page: 1, per_page: 1, order: 'instalacao_nome',
                      order_direction: 'asc' }

        expect(response.parsed_body).to include(
          'data' => [
            a_hash_including(
              'id' => 29,
              'actions' => {
                'delete' => false
              },
              'instalacao_fisica' => {
                'id' => 13,
                'codigo' => 'I3',
                'nome' => 'Instalacao 3',
                'subtipo_instalacao' => {
                  'id' => 2,
                  'codigo' => 'S1',
                  'nome' => 'Subtipo 1'
                },
                'tipo_instalacao_fisica' => {
                  'id' => 4,
                  'codigo' => 'T1',
                  'nome' => 'Tipo 1'
                }
              },
              'qtde_instalacoes' => 2,
              'qtde_leitos' => 5,
              'unidade_saude_id' => 88
            )
          ],
          'meta' => {
            'current_page' => '1',
            'total_pages' => 1,
            'total_count' => 1
          }
        )
      end

      context 'when user is not authenticated' do
        before do
          request.headers['Authorization'] = nil
        end

        it 'returns an unauthorized response' do
          get :index, params: { unidade_saude_id: unidade_saude.id }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
