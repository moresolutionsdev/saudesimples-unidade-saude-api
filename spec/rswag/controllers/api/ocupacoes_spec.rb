# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/ocupacoes', type: :request do
  path '/api/unidade_saude/ocupacoes' do
    get('list ocupacos') do
      tags 'Ocupacoes'
      description 'Listar as ocupacoes de uma unidade de saude'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da ocupacao'
      parameter name: :codigo, in: :query, type: :string, description: 'Código da ocupacao'
      parameter name: :saude, in: :query, type: :string, description: 'Saude da ocupacao'
      parameter name: :search_term, in: :query, type: :string, description: 'Termo de busca'

      response(200, 'successful') do
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
