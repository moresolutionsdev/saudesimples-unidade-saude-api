# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/municipios', type: :request do
  path '/api/estados/{estado_id}/municipios' do
    # You'll want to customize the parameter types...
    parameter name: 'estado_id', in: :path, type: :string, description: 'estado_id'

    get('list municipios') do
      tags 'Endereço'
      description 'Listar os municipios de um estado'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      response(200, 'successful') do
        let(:estado_id) { '123' }

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
