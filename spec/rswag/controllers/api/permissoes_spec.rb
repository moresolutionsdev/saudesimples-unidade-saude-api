require 'swagger_helper'

RSpec.describe 'api/permissoes', type: :request do
  path '/api/unidade_saude/permissoes' do
    get('list permissos') do
      tags 'Permissoes'
      description 'Listar as permissões de uma unidade de saude'
      produces 'application/json'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da permissão'
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
