# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/profissional', type: :request do

  path '/api/unidade_saude/{unidade_saude_id}/profissional' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    post('create profissional') do
      tags 'Profissionais'
      description 'Vincular um profissional a uma unidade de saude'
      produces 'application/json'
      parameter name: :profissional, in: :body, schema: {
        type: :object,
        properties: {
          profissional_id: { type: :string },
          ocupacao_id: { type: :string },
        },
      }

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
