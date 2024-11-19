require 'swagger_helper'

RSpec.describe 'api/servicos_apoio/servicos_apoio', type: :request do
  path '/api/unidade_saude/{unidade_saude_id}/servicos_apoio' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    get('list servicos_apoios') do
      tags 'Servicos Apoio'
      description 'Listar os servicos de apoio de uma unidade de saude'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end

    post('create servicos_apoio') do
      tags 'Servicos Apoio'
      description 'Criar um servico de apoio para uma unidade de saude'
      produces 'application/json'
      parameter name: :servico_apoio, in: :body, schema: {
        type: :object,
        properties: {
          tipo_servico_apoio_id: { type: :string },
          caracteristica_servico_id: { type: :string },
        },
        required: %w[tipo_servico_apoio_id caracteristica_servico_id]
      }

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/unidade_saude/{unidade_saude_id}/servicos_apoio/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    delete('delete servicos_apoio') do
      tags 'Servicos Apoio'
      description 'Excluir um servico de apoio de uma unidade de saude'
      produces 'application/json'

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end
end
