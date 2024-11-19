# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/estados', type: :request do
  path '/api/estados' do
    get('list estados') do
      tags 'Estados'
      description 'Listar os estados'

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
