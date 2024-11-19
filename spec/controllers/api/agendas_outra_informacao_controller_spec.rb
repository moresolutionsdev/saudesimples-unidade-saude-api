# frozen_string_literal: true

RSpec.describe Api::AgendasOutraInformacaoController do
  include_context 'with an authenticated token'
  let!(:agenda) { create(:agenda) }
  let!(:outra_informacao_1) { create(:outra_informacao) }
  let!(:agenda_outra_informacao_1) do
    create(:agenda_outra_informacao, agenda:, outra_informacao: outra_informacao_1)
  end

  describe 'GET #index' do
    it 'returns the correct structure' do
      get :index, params: { agenda_id: agenda.id }

      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['data']).to be_an(Array)
      expect(json['data'].first['id']).to eq(agenda_outra_informacao_1.id)
      expect(json['data'].first['agenda_id']).to eq(agenda.id)
    end

    it 'returns paginated data' do
      get :index, params: { agenda_id: agenda.id, page: 1, per_page: 5 }

      json = response.parsed_body
      expect(json['meta']['current_page']).to eq(1)
      expect(json['meta']['total_pages']).to eq(1)
      expect(json['meta']['total_count']).to eq(1)
    end
  end
end
