# frozen_string_literal: true

RSpec.describe Api::TipoEquipesController do
  describe 'GET /api/tipo_equipes' do
    include_context 'with an authenticated token'

    let!(:tipo_equipe1) { create(:tipo_equipe, codigo: '11', sigla: 'EQP1', descricao: 'Equipe Teste 1') }
    let!(:tipo_equipe2) { create(:tipo_equipe, codigo: '12', sigla: 'EQP2', descricao: 'Equipe Teste 2') }

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of tipo_equipes' do
      get :index
      json_response = response.parsed_body

      expect(json_response['data'].size).to eq(2)
      expect(json_response['data']).to eq([
        {
          'id' => tipo_equipe1.id,
          'codigo' => tipo_equipe1.codigo,
          'sigla' => tipo_equipe1.sigla,
          'descricao' => tipo_equipe1.descricao,
          'label' => "#{tipo_equipe1.codigo} - #{tipo_equipe1.sigla} - #{tipo_equipe1.descricao}"
        },
        {
          'id' => tipo_equipe2.id,
          'codigo' => tipo_equipe2.codigo,
          'sigla' => tipo_equipe2.sigla,
          'descricao' => tipo_equipe2.descricao,
          'label' => "#{tipo_equipe2.codigo} - #{tipo_equipe2.sigla} - #{tipo_equipe2.descricao}"
        }
      ])
    end

    it 'filters tipo_equipes by sigla' do
      get :index, params: { sigla: 'EQP1' }
      json_response = response.parsed_body

      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'].first['sigla']).to eq(tipo_equipe1.sigla)
    end

    it 'filters tipo_equipes by descricao' do
      get :index, params: { descricao: 'Equipe Teste 2' }
      json_response = response.parsed_body

      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'].first['descricao']).to eq(tipo_equipe2.descricao)
    end

    it 'returns paginated results' do
      get :index, params: { page: 1, per_page: 1 }
      json_response = response.parsed_body

      expect(json_response['data'].size).to eq(1)
      expect(json_response['meta']['current_page']).to eq('1')
      expect(json_response['meta']['total_pages']).to eq(2)
      expect(json_response['meta']['total_count']).to eq(2)
    end
  end
end
