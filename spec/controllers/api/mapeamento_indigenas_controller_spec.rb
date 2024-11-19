# frozen_string_literal: true

RSpec.describe Api::MapeamentoIndigenasController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let!(:mapeamento_indigena) { create(:mapeamento_indigena) }
    let(:params) { { page: 1, per_page: 10 } }

    before do
      get :index, params:
    end

    it 'returns a 200 status code' do
      expect(response).to have_http_status(:ok)
    end
  end
end
