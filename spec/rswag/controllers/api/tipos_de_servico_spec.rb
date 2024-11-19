# frozen_string_literal: true
require 'swagger_helper'

RSpec.describe 'api/tipos_de_servico', type: :request do
  path '/api/unidade_saude/servicos' do
    get('list tipos_de_servicos') do
      tags 'Tipos de Serviço'
      consumes 'application/json'
      produces 'application/json'
      description 'Listar os tipos de serviço disponíveis'
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
