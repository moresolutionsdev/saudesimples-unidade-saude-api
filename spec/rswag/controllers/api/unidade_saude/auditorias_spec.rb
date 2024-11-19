# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/auditorias', type: :request do
  path '/api/unidade_saude/{id}/auditorias' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('list auditoria') do
      tags 'Auditorias'
      description 'Listar as auditorias de uma unidade de saude'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :date_start, in: :query, type: :string, description: 'Data de início'
      parameter name: :date_end, in: :query, type: :string, description: 'Data de fim'

      response(200, 'successful') do
        let(:id) { '123' }

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
