# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/instalacao_fisica/instalacao_unidades', type: :request do
  path '/api/unidade_saude/{id}/instalacao_fisica' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    post('create instalacao_unidade') do
      tags 'Instalacao Unidades'
      description 'Criar uma instalacao unidade para uma unidade de saude'
      produces 'application/json'
      parameter name: :instalacao_unidade, in: :body, schema: {
        type: :object,
        properties: {
          instalacao_fisica_id: { type: :string },
          qtde_instalacoes: { type: :integer },
          qtde_leitos: { type: :integer },
        },
      }

      response(200, 'successful') do
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

  path '/api/unidade_saude/{unidade_saude_id}/instalacao_fisica' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    get('list instalacao_unidades') do
      tags 'Instalacao Unidades'
      description 'Listar as instalacoes fisicas de uma unidade de saude'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da instalacao'

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

  path '/api/unidade_saude/{unidade_saude_id}/instalacao/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    delete('delete instalacao_unidade') do
      tags 'Instalacao Unidades'
      description 'Deletar uma instalacao unidade de uma unidade de saude'
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
