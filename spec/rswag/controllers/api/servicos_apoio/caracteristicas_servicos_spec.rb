# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/servicos_apoio/caracteristicas_servicos', type: :request do
  path '/api/unidade_saude/servicos_apoio/caracteristica' do
    get('list caracteristicas_servicos') do
      tags 'Servicos Apoio'
      description 'Listar as caracteristicas dos servicos de apoio de uma unidade de saude'
      produces 'application/json'
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
