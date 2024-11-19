# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncUnidadesDeSaudeWithCNESJob do
  let(:page) { 1 }
  let(:mock_response) do
    {
      success: true,
      data: {
        unidades_de_saude: [
          {
            cnes: '123456',
            nome_fantasia: 'Unidade Teste',
            cnpj: '00.000.000/0001-91',
            tipo_unidade_saude: 'UBS',
            codigo_subtipo_unidade_saude: '001',
            telefone1: '123456789',
            fax: '123456789',
            email: 'teste@unidade.com',
            enderecos: [
              {
                cep: '12345-678',
                logradouro: 'Rua Teste',
                numero: '123',
                bairro: 'Bairro Teste',
                complemento: 'Complemento Teste'
              }
            ]
          }
        ]
      },
      paginate: { next_page: nil }
    }
  end

  let(:endereco_service_instance) { instance_double(UnidadeSaude::UnidadeSaudeEnderecoService) }

  before do
    allow(CNESApi::CNESRepository).to receive(:lista_unidade_saude).and_return(mock_response)
    allow(UnidadeSaudeRepository).to receive(:upsert_unidade_saude)
    allow(UnidadeSaude::UnidadeSaudeEnderecoService).to receive(:new).and_return(endereco_service_instance)
    allow(endereco_service_instance).to receive(:buscar_cep).and_return({
      data: {
        municipio: double('Municipio', id: 1),
        estado: double('Estado', id: 1)
      }
    })
    allow(TipoUnidade).to receive(:find_by).and_return(double('TipoUnidade', id: 1))
    allow(DescricaoSubtipoUnidade).to receive(:find_by).and_return(double('DescricaoSubtipoUnidade', id: 1))
    allow(Rails.logger).to receive(:error)
  end

  it 'calls the busca_unidades_saude_api method with the correct page' do
    described_class.perform_now(page)
    expect(CNESApi::CNESRepository).to have_received(:lista_unidade_saude).with(page:)
  end

  it 'creates or updates the unidade saude' do
    described_class.perform_now(page)
    expect(UnidadeSaudeRepository).to have_received(:upsert_unidade_saude).with('123456', anything)
  end

  it 'logs an error if an exception is raised' do
    allow(CNESApi::CNESRepository).to receive(:lista_unidade_saude).and_raise(StandardError.new('API Error'))
    described_class.perform_now(page)
    expect(Rails.logger).to have_received(:error).with(instance_of(StandardError))
  end

  it 'loops through pages until next_page is nil' do
    mock_response_with_next_page = mock_response.merge(paginate: { next_page: 2 })
    allow(CNESApi::CNESRepository).to receive(:lista_unidade_saude).and_return(mock_response_with_next_page,
                                                                               mock_response)

    described_class.perform_now(page)
    expect(CNESApi::CNESRepository).to have_received(:lista_unidade_saude).twice
  end
end
