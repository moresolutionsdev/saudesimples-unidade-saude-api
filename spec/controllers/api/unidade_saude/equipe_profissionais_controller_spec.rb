# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::EquipeProfissionaisController do
  describe 'GET #by_profissional' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { create(:unidade_saude) }
    let(:equipe) { create(:equipe, unidade_saude:) }
    let(:profissional) { create(:profissional) }
    let(:equipe_profissionais) { create_list(:equipe_profissional, 3, equipe:) }

    before do
      equipe_profissionais.first.update(profissional_id: profissional.id)
      equipe_profissionais.last.update(profissional_id: profissional.id)
      get :by_profissional, params: { profissional_id: profissional.id }
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of equipe_profissionais' do
      parsed_response = response.parsed_body
      expect(parsed_response['data'].size).to eq(2)
    end

    it 'returns the correct ids' do
      parsed_response = response.parsed_body

      response_ids = parsed_response['data'].pluck('profissional_id')

      expect(response_ids).to all(eq(profissional.id))
    end
  end

  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { create(:unidade_saude) }
    let(:equipe) { create(:equipe, unidade_saude:) }
    let(:equipe_profissionais) { create_list(:equipe_profissional, 3, equipe:) }

    before do
      equipe_profissionais
      get :index, params: { unidade_saude_id: unidade_saude.id, equipe_id: equipe.id }
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of equipe_profissionais' do
      parsed_response = response.parsed_body
      expect(parsed_response['data'].size).to eq(3)
    end

    it 'returns the correct ids' do
      parsed_response = response.parsed_body
      response_ids = parsed_response['data'].pluck('id')
      expected_ids = equipe_profissionais.map(&:id)

      expect(response_ids).to match_array(expected_ids)
    end

    it 'returns the correct attributes for each equipe_profissional' do
      parsed_response = response.parsed_body
      equipe_profissional = equipe_profissionais.first
      response_profissional = parsed_response['data'].find { |ep| ep['id'] == equipe_profissional.id }

      expect(response_profissional['profissional']['nome']).to eq(equipe_profissional.profissional.nome)
      expect(response_profissional['ocupacao']['nome']).to eq(equipe_profissional.ocupacao.nome)
    end

    it 'includes pagination metadata' do
      parsed_response = response.parsed_body
      meta = parsed_response['meta']

      expect(meta['current_page']).to eq(1)
      expect(meta['total_pages']).to eq(1)
      expect(meta['total_count']).to eq(3)
    end
  end
end
