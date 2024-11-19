require 'swagger_helper'

RSpec.describe 'api/servicos_apoio/tipos', type: :request do
  path '/api/unidade_saude/servicos_apoio/tipos' do
    get('list tipos') do
      tags 'Servicos Apoio'
      description 'Listar os tipos dos servicos de apoio de uma unidade de saude'
      produces 'application/json'

      parameter name: :nome, in: :query, type: :string, description: 'Nome do tipo'

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
