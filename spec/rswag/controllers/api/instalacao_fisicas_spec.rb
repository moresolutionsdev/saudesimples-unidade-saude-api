# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/instalacao_fisicas', type: :request do
  path '/api/unidade_saude/instalacao_fisica' do
    get('search instalacao_fisica') do
      tags 'Instalacao Fisica'
      description 'Listar as instalacoes fisicas de uma unidade de saude'
      produces 'application/json'
      parameter name: :id, in: :query, type: :string, description: 'Id da instalacao fisica'
      parameter name: :nome, in: :query, type: :string, description: 'Nome da instalacao fisica'
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
