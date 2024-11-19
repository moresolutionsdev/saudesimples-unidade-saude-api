# frozen_string_literal: true
require 'swagger_helper'

RSpec.describe 'api/servicos_classificacao', type: :request do
  path '/api/unidade_saude/servicos/classificacao' do
    get('list servicos_classificacaos') do
      tags 'Servicos'
      description 'Listar os servicos de classificacao de uma unidade de saude'
      produces 'application/json'
      parameter name: :codigo_servico, in: :query, type: :string, required: true
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
