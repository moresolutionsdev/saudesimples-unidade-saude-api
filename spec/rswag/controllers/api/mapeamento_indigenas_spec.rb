# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/mapeamento_indigenas', type: :request do
  path '/api/mapeamento_indigenas' do
    get('list mapeamento_indigenas') do
      tags 'Mapeamento Indigenas'
      description 'Listar os mapeamentos de indigenas'
      produces 'application/json'
      parameter name: :search_term, in: :query, type: :string, description: 'Termo de busca'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
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
