# frozen_string_literal: true

RSpec.describe Api::EstadosController do
  describe 'GET #index' do
    subject { response }

    include_context 'with an authenticated token'

    let!(:estado) { create(:estado) }
    let(:serialized_resource) do
      {
        data: [
          {
            id: estado.id,
            nome: estado.nome,
            uf: estado.uf,
            codigo_dne: estado.codigo_dne,
            pais_id: estado.pais_id
          }
        ]
      }.with_indifferent_access
    end

    before do
      get :index
    end

    it { is_expected.to have_http_status(:ok) }

    it 'returns serialized response' do
      expect(subject.parsed_body).to eq(serialized_resource)
    end
  end
end
