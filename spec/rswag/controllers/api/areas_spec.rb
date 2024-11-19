# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/areas', type: :request do
  path '/api/areas' do
    get('list areas') do
      tags 'Areas'
      description 'Listar as areas'
      produces 'application/json'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da area'
      parameter name: :codigo, in: :query, type: :string, description: 'Código da area'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :municipio_id, in: :query, type: :string, description: 'Municipio ID'
      parameter name: :segmento_id, in: :query, type: :string, description: 'Segmento ID'

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
