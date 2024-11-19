# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/profissionais', type: :request do
  path '/api/unidade_saude/profissionais' do
    get('list profissionais') do
      tags 'Profissionais'
      description 'Listar os profissionais de uma unidade de saude'
      produces 'application/json'
      parameter name: :nome, in: :query, type: :string, description: 'Nome do profissional'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
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
