# frozen_string_literal: true

RSpec.describe Api::PaisesController do
  describe 'GET #index' do
    subject { response }

    include_context 'with an authenticated token'

    let(:total_count) { Pais.count }
    let(:current_page) { 1 }
    let(:total_pages) { 1 }

    context 'when given page/per param' do
      before do
        create_list(:pais, 10).map { |pais| pais.nome.upcase }

        get :index, params: { page: 2, per_page: 5 }
      end

      it { is_expected.to have_http_status(:ok) }

      it 'return collection from page' do
        expect(subject.parsed_body[:data].size).to eq(5)
      end

      it 'return current page' do
        expect(subject.parsed_body.dig(:meta, :current_page)).to eq(2)
      end

      it 'return total pages' do
        expect(subject.parsed_body.dig(:meta, :total_pages)).to eq(2)
      end

      it 'return collection capitalized' do
        nome = subject.parsed_body[:data].first['nome']

        expect(nome).not_to eq(nome.upcase)
      end
    end

    context 'when given page with empty result' do
      before do
        create_list(:pais, 2)

        get :index, params: { page: 2, per_page: 10 }
      end

      it 'return empty' do
        expect(subject.parsed_body[:data]).to be_empty
      end
    end

    context 'when something went wrong' do
      before do
        allow(PaisRepository).to receive(:order).and_raise(StandardError)

        get :index, params: {}
      end

      it 'render error 500' do
        expect(subject.parsed_body[:message]).to eq('Erro ao listar paises')
      end
    end
  end
end
