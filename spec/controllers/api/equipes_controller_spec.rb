# frozen_string_literal: true

RSpec.describe Api::EquipesController do
  describe 'POST #create' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { create(:unidade_saude) }
    let(:area_relacionada) { create(:area) }
    let(:tipo_equipe) { create(:tipo_equipe) }
    let(:mapeamento_indigena) { create(:mapeamento_indigena) }
    let(:profissional) { create(:profissional) }
    let(:ocupacao) { create(:ocupacao) }

    let(:params) do
      {
        'equipe' => {
          'unidade_saude_id' => unidade_saude.id,
          'codigo' => 123,
          'nome' => 'Equipe 1',
          'area' => area_relacionada.codigo,
          'tipo_equipe_id' => tipo_equipe.id,
          'data_ativacao' => '2021-01-01',
          'data_desativacao' => '2022-01-01',
          'motivo_desativacao' => 'reorganizacao',
          'populacao_assistida' => false,
          'mapeamento_indigena_id' => mapeamento_indigena.id,
          'equipes_profissionais_attributes' => [
            {
              'profissional_id' => profissional.id,
              'ocupacao_id' => ocupacao.id,
              'codigo_micro_area' => 222,
              'entrada' => '2021-01-01',
              'data_saida' => '2022-01-01',
              '_destroy' => false
            }
          ]
        }
      }
    end

    context 'when creation is successful' do
      it 'returns a 201 status code' do
        post(:create, params:)
        expect(response).to have_http_status(:created)
      end

      it 'creates a new equipe with nested equipes_profissionais' do
        expect { post :create, params: }.to(
          change(Equipe, :count).by(1).and(change(EquipeProfissional, :count).by(1))
        )
      end

      it 'returns the created equipe' do
        post(:create, params:)

        expect(response.parsed_body).to eq(
          'data' => {
            'id' => Equipe.last.id,
            'codigo' => 123,
            'nome' => 'Equipe 1',
            'area' => area_relacionada.codigo,
            'data_ativacao' => '2021-01-01',
            'data_desativacao' => '2022-01-01',
            'motivo_desativacao' => 'reorganizacao',
            'populacao_assistida' => false,
            'categoria_equipe' => nil,
            'unidade_saude' => {
              'id' => unidade_saude.id,
              'codigo_cnes' => unidade_saude.codigo_cnes,
              'nome' => unidade_saude.nome,
              'exportacao_esus' => unidade_saude.exportacao_esus
            },
            'tipo_equipe' => {
              'id' => tipo_equipe.id,
              'codigo' => tipo_equipe.codigo,
              'sigla' => tipo_equipe.sigla,
              'descricao' => tipo_equipe.descricao
            },
            'mapeamento_indigena' => {
              'id' => mapeamento_indigena.id,
              'codigo_dsei' => mapeamento_indigena.codigo_dsei,
              'dsei' => mapeamento_indigena.dsei,
              'polo_base' => mapeamento_indigena.polo_base,
              'aldeia' => mapeamento_indigena.aldeia
            }
          }
        )
      end
    end

    context 'when creation fails' do
      it 'returns a 422 status code and renders the error message' do
        error = 'Some error message'

        allow(Equipes::CriarService).to receive(:call).and_return(failure: error)

        post(:create, params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error)
      end
    end
  end

  describe 'GET #show' do
    include_context 'with an authenticated token'

    let!(:unidade_saude) { create(:unidade_saude) }
    let!(:equipe) { create(:equipe, unidade_saude:) }
    let!(:equipe_profissional) { create(:equipe_profissional, equipe:) }

    let(:params) do
      {
        id: equipe.id
      }
    end

    context 'when the service call is successful' do
      before do
        get :show, params:
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct JSON structure' do
        expect(response.parsed_body).to include(
          'data' => include(
            'area' => equipe.area,
            'categoria_equipe' => include(
              'id' => equipe.categoria_equipe.id,
              'label' => equipe.categoria_equipe.label,
              'nome' => equipe.categoria_equipe.nome
            ),
            'codigo' => equipe.codigo,
            'data_ativacao' => equipe.data_ativacao.as_json,
            'data_desativacao' => equipe.data_desativacao.as_json,
            'motivo_desativacao' => equipe.motivo_desativacao,
            'nome' => equipe.nome,
            'populacao_assistida' => equipe.populacao_assistida,
            'tipo_equipe' => include(
              'descricao' => equipe.tipo_equipe.descricao,
              'id' => equipe.tipo_equipe.id,
              'sigla' => equipe.tipo_equipe.sigla
            ),
            'unidade_saude' => include(
              'codigo_cnes' => equipe.unidade_saude.codigo_cnes,
              'id' => equipe.unidade_saude.id,
              'nome' => equipe.unidade_saude.nome
            )
          )
        )
      end
    end
  end

  describe 'PUT #update' do
    include_context 'with an authenticated token'

    let!(:unidade_saude) { create(:unidade_saude) }
    let!(:equipe) { create(:equipe, unidade_saude:) }
    let!(:equipe_profissional) { create(:equipe_profissional, equipe:) }

    let(:params) do
      {
        'id' => equipe.id,
        'equipe' => {
          'unidade_saude_id' => unidade_saude.id,
          'codigo' => 123,
          'nome' => 'Equipe 1',
          'area' => create(:area).codigo,
          'tipo_equipe_id' => create(:tipo_equipe).id,
          'data_ativacao' => '2021-01-01',
          'data_desativacao' => '2022-01-01',
          'motivo_desativacao' => 'reorganizacao',
          'populacao_assistida' => false,
          'mapeamento_indigena_id' => create(:mapeamento_indigena).id,
          'equipes_profissionais_attributes' => [
            {
              'id' => equipe_profissional.id,
              'profissional_id' => equipe_profissional.profissional.id,
              'ocupacao_id' => equipe_profissional.ocupacao.id,
              'codigo_micro_area' => 222,
              'entrada' => '2021-01-01',
              'data_saida' => '2022-01-01',
              '_destroy' => false
            }
          ]
        }
      }
    end

    context 'when update is successful' do
      it 'returns a 200 status code' do
        put(:update, params:)
        expect(response).to have_http_status(:ok)
      end

      it 'updates the equipe with nested equipes_profissionais' do
        params['equipe']['nome'] = 'Equipe Master'
        params['equipe']['equipes_profissionais_attributes'].first['codigo_micro_area'] = 333

        put(:update, params:)

        equipe.reload
        expect(equipe.nome).to eq('Equipe Master')
        expect(equipe.equipes_profissionais.first.codigo_micro_area).to eq(333)
      end

      it 'removes the equipe_profissional when _destroy is true' do
        params['equipe']['equipes_profissionais_attributes'].first['_destroy'] = true

        put(:update, params:)

        equipe.reload
        expect(equipe.equipes_profissionais).to be_empty
      end

      it 'creates a new equipe_profissional when _destroy is false and id is nil' do
        new_equipe_profissional = {
          'profissional_id' => create(:profissional).id,
          'ocupacao_id' => create(:ocupacao).id,
          'codigo_micro_area' => 444,
          'entrada' => '2021-01-01',
          'data_saida' => '2022-01-01'
        }
        params['equipe']['equipes_profissionais_attributes'] << new_equipe_profissional

        put(:update, params:)

        equipe.reload
        expect(equipe.equipes_profissionais.count).to eq(2)
      end
    end
  end

  describe 'PUT #alternar_situacao' do
    include_context 'with an authenticated token'

    let(:equipe_ativada) do
      create(:equipe, data_ativacao: Time.zone.now, data_desativacao: nil, motivo_desativacao: nil)
    end
    let(:equipe_desativada) do
      create(:equipe, data_ativacao: 1.day.ago, data_desativacao: Time.zone.now,
                      motivo_desativacao: 'reorganizacao')
    end

    before do
      freeze_time
    end

    context 'when update is successful' do
      it 'activates the equipe' do
        params = { id: equipe_desativada.id }

        put(:alternar_situacao, params:)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to include(
          'id' => equipe_desativada.id,
          'data_ativacao' => Time.zone.now.to_date.to_s,
          'data_desativacao' => nil,
          'motivo_desativacao' => nil
        )
      end

      it 'deactivates the equipe' do
        params = { id: equipe_ativada.id }

        put(:alternar_situacao, params:)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']).to include(
          'id' => equipe_ativada.id,
          'data_ativacao' => equipe_ativada.data_ativacao.to_date.to_s,
          'data_desativacao' => Time.zone.now.to_date.to_s,
          'motivo_desativacao' => 'reorganizacao'
        )
      end
    end

    context 'when update fails' do
      it 'returns a 422 status code and renders the error message' do
        error = 'Some error message'
        allow(Equipes::AlternarSituacaoService).to receive(:call).and_return(failure: error)

        params = { id: equipe_ativada.id }
        put(:alternar_situacao, params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error)
      end
    end

    describe 'DELETE #destroy' do
      include_context 'with an authenticated token'

      let!(:unidade_saude) { create(:unidade_saude) }

      context 'when user has permission' do
        let!(:equipe) { create(:equipe, unidade_saude:) }
        let!(:equipe_profissional) { create(:equipe_profissional, equipe:) }
        let!(:perfil_usuario) { create(:perfil_usuario, usuario_id: current_user.id) }

        it 'render 204 and delete equipe' do
          delete :destroy, params: { id: equipe.id }

          expect(response).to have_http_status(:no_content)
          expect { equipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when user has not permission' do
        let!(:equipe) { create(:equipe, unidade_saude:) }
        let!(:equipe_profissional) { create(:equipe_profissional, equipe:) }

        it 'render 422' do
          delete :destroy, params: { id: equipe.id }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET #exists' do
    include_context 'with an authenticated token'

    let!(:unidade_saude) { create(:unidade_saude) }
    let!(:equipe) { create(:equipe, unidade_saude:) }

    context 'when there is an equipe with the given codigo' do
      it 'returns a successful response' do
        get :exists, params: { codigo: equipe.codigo }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include('data' => include('id' => equipe.id))
      end
    end

    context 'when there is no equipe with the given codigo' do
      it 'returns a unprocessable_entity response with the error message' do
        get :exists, params: { codigo: 123 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include('message' => 'Equipe não encontrada')
      end
    end

    context 'when the codigo is not given' do
      it 'returns bad_request response with the error message' do
        get(:exists, params: {})

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include('param is missing or the value is empty: codigo')
      end
    end
  end
end
