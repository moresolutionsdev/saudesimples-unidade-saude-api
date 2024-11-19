# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/audits', type: :request do
  path '/api/unidade_saude/audits' do
    get('list audits') do
      tags 'Audits'
      description 'Listar os audits pelo auditable'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :date_start, in: :query, type: :string, description: 'Data de início'
      parameter name: :date_end, in: :query, type: :string, description: 'Data de fim'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'
      parameter name: :auditable, in: :query, type: :string, description: 'Auditable'

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
