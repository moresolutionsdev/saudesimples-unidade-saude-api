require 'swagger_helper'

RSpec.describe 'api/importacao/cnes', type: :request do
  path '/api/unidade_saude/importacao/cnes' do
    post('create cne') do
      tags 'Importação CNES'
      description 'Importa unidades de saúdes a partir de um array de cnes, utilizando o serviço de importação de CNES'
      consumes 'application/json'
      parameter name: :cnes, in: :body, schema: {
        type: :array,
        items: {
          type: :string
        }
      }

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
