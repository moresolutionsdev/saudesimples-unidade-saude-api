# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/equipamento', type: :request do
  path '/api/equipamento' do
    get('list equipamentos') do
      tags 'Equipamentos'
      description 'Listar os equipamentos'
      produces 'application/json'
      parameter name: :nome, in: :query, type: :string, description: 'Nome do equipamento'
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
