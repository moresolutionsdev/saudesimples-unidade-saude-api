# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/paises', type: :request do
  path '/api/paises' do
    get('list paises') do
      tags 'Endereço'
      produces 'application/json'
      description 'Listar os paises'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
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
