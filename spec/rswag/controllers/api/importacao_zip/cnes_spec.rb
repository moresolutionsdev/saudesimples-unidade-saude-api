require 'swagger_helper'

RSpec.describe 'api/importacao_zip/cnes', type: :request do
  path '/api/unidade_saude/importacao_zip/cnes' do
    post('create cne') do
      tags 'Importação CNES'
      description 'Importar um arquivo zip com os dados do CNES'
      parameter name: :file, in: :formData, type: :file, required: true
      consumes 'multipart/form-data'

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
