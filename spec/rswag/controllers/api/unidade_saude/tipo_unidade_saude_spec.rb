# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/tipo_unidade_saude', type: :request do
  path '/api/unidade_saude/tipo_unidade_saude' do
    get('list tipo_unidade_saudes') do
      tags 'Tipo Unidade Saude'
      description 'Listar os tipos de unidade de saude'
      produces 'application/json'
      parameter name: :nome, in: :query, type: :string, description: 'Nome do tipo de unidade de saude'
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
