# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/nacionalidades', type: :request do
  path '/api/nacionalidades' do
    get('list nacionalidades') do
      tags 'Nacionalidades'
      description 'Listar as nacionalidades'
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
