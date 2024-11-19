# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::EquipesController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:equipe_params) do
      {
        'unidade_saude_id' => '1',
        'order' => 'nome',
        'order_direction' => 'asc',
        'page' => '1',
        'per_page' => '10'
      }
    end

    context 'when service call fails' do
      it 'returns a 422 status code and renders the error message' do
        error = 'Some error message'

        allow(UnidadeSaude::Equipes::BuscarService).to receive(:call).with(equipe_params.to_h)
          .and_return(Failure.new(error))

        get :index, params: equipe_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error)
      end
    end
  end

  describe 'GET #show' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { create(:unidade_saude) }
    let(:equipe) { create(:equipe, unidade_saude:) }

    let(:show_params) do
      {
        unidade_saude_id: unidade_saude.id,
        id: equipe.id
      }
    end

    context 'when the service call is successful' do
      before do
        allow(UnidadeSaude::Equipes::DetalharService).to receive(:call)
          .with(hash_including(
                  unidade_saude_id: unidade_saude.id.to_s, id: equipe.id.to_s
                ))
          .and_return(Success.new(equipe))

        get :show, params: show_params
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct JSON structure' do
        json_response = response.parsed_body
        expect(json_response).to include(
          'data' => include(
            'id' => equipe.id,
            'actions' => include(
              'show' => false,
              'delete' => false,
              'edit' => false
            ),
            'area' => equipe.area,
            'categoria_equipe' => include(
              'id' => equipe.categoria_equipe.id,
              'label' => equipe.categoria_equipe.label,
              'nome' => equipe.categoria_equipe.nome
            ),
            'cnes_equipe' => include(
              'id' => equipe.unidade_saude&.id,
              'codigo' => equipe.unidade_saude&.codigo_cnes,
              'nome' => equipe.unidade_saude&.nome
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
            )
          )
        )
      end
    end
  end

  describe 'GET #minimal' do
    include_context 'with an authenticated token'

    let(:valid_params) { { term: 'Equipe Teste' } }
    let(:equipe) { create(:equipe, nome: 'Equipe Teste', codigo: 12_345) }

    context 'when the service returns success' do
      it 'renders a successful response with serialized equipes' do
        allow(Equipes::ListEquipesService).to receive(:call)
          .and_return(Success.new([equipe]))

        get :minimal, params: valid_params, format: :json, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          'data' => [
            {
              'id' => equipe.id,
              'nome' => equipe.nome,
              'codigo' => equipe.codigo
            }
          ]
        )
      end
    end

    context 'when the service returns failure' do
      it 'renders an unprocessable entity response with error message' do
        allow(Equipes::ListEquipesService).to receive(:call)
          .and_return(Failure.new('Something went wrong'))

        get :minimal, params: valid_params, format: :json, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['message']).to eq('Something went wrong')
      end
    end
  end
end
