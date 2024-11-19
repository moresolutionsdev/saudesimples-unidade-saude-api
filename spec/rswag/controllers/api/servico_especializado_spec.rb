# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/servico_especializado', type: :request do
  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }
  end

  path '/api/unidade_saude/{unidade_saude_id}/servico_especializado' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    post('create servico_especializado') do
      tags 'Servicos'
      description 'Criar um servico especializado para uma unidade de saude'
      produces 'application/json'
      parameter name: :servico_especializado, in: :body, schema: {
        type: :object,
        properties: {
          codigo_classificacao: { type: :string },
          caracteristica_servico_id: { type: :string },
          codigo_cnes_terceiro: { type: :string },
          atende_ambulatorial_nao_sus: { type: :boolean },
          atende_ambulatorial_sus: { type: :boolean },
          atende_hospitalar_nao_sus: { type: :boolean },
          atende_hospitalar_sus: { type: :boolean },
          endereco_complementar_unidade_id: { type: :string },
          servico_id: { type: :string }
        },
        required: %w[codigo_classificacao caracteristica_servico_id codigo_cnes_terceiro atende_ambulatorial_nao_sus
                     atende_ambulatorial_sus atende_hospitalar_nao_sus atende_hospitalar_sus
                     endereco_complementar_unidade_id servico_id]
      }

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }

        run_test!
      end
    end
  end

  path '/api/unidade_saude/{unidade_saude_id}/servico_especializado/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    delete('delete servico_especializado') do
      tags 'Servicos'
      description 'Excluir um servico especializado de uma unidade de saude'
      produces 'application/json'
      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }
        let(:id) { '123' }

        run_test!
      end
    end
  end
end
