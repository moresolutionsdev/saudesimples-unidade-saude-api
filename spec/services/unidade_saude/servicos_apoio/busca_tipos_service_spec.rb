# frozen_string_literal: true

RSpec.describe UnidadeSaude::ServicosApoio::BuscaTiposService, type: :service do
  describe '#call' do
    context 'quando encontra um serviço pelo nome' do
      before do
        create(:tipo_servico_apoio)
      end

      let(:nome_servico) { 'Tipo Serviço Apoio 1' }
      let(:params) { { nome: nome_servico } }
      let(:service) { described_class.new(params) }
      let(:response) { service.call }

      it 'retorna o sucesso com dados do serviço apoio' do
        expect(response).to be_success
      end

      it 'deve retornar o nome correto do primeiro serviço' do
        expect(response.data.first.name).to eq(nome_servico)
      end
    end

    context 'quando encontra mais de um serviço pelo nome' do
      before do
        create_list(:tipo_servico_apoio, 3)
      end

      let(:nome_servico) { 'Tipo Serviço Apoio 1' }
      let(:params) { { nome: nome_servico } }
      let(:service) { described_class.new(params) }
      let(:response) { service.call }

      it 'retorna o sucesso com dados dos serviços de apoio' do
        expect(response).to be_success
      end

      it 'deve retornar uma array de dados contendo 3 serviços de apoio' do
        expect(response.data.size).to eq(3)
      end

      it 'deve retornar o nome correto do primeiro serviço' do
        expect(response.data.last.name).to eq(nome_servico)
      end
    end

    context 'quando não encontra serviço algum' do
      let(:nome_servico) { 'inexistente' }
      let(:params) { { nome: nome_servico } }
      let(:service) { described_class.new(params) }
      let(:response) { service.call }

      it 'retorna o sucesso com dados dos serviços de apoio' do
        expect(response).to be_success
      end

      it 'deve retornar uma array de dados vazio' do
        expect(response.data).to be_empty
      end
    end
  end
end
