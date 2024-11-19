# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/micro_areas', type: :request do
  path '/api/micro_areas' do
    get('list micro_areas') do
      tags 'Micro Areas'
      description 'Listar as micro areas'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da micro area'
      parameter name: :area_id, in: :query, type: :integer, description: 'ID da area'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
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
