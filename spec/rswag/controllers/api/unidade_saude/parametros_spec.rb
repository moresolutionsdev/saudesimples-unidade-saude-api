# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/parametros', type: :request do
  path '/api/unidade_saude/{unidade_saude_id}/parametros' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    get('list parametros') do
      tags 'Parametros'
      description 'Listar os parametros de uma unidade de saude'
      produces 'application/json'

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }

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
