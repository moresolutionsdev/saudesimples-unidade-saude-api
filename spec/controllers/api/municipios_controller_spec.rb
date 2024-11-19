# frozen_string_literal: true

RSpec.describe Api::MunicipiosController do
  describe 'GET #index' do
    subject { response }

    include_context 'with an authenticated token'

    let(:estado) { create(:estado) }

    context 'when given page/per param' do
      before do
        create_list(:municipio, 10, estado:)

        get :index, params: { estado_id: estado.id }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'return collection from page' do
        expect(subject.parsed_body[:data].size).to eq(10)
      end
    end

    context 'when something went wrong' do
      before do
        allow(MunicipioRepository).to receive(:where).and_raise(StandardError)

        get :index, params: { estado_id: estado.id }
      end

      it 'render error 500' do
        expect(subject.parsed_body[:message]).to eq('Erro ao listar municipios')
      end
    end
  end
end
