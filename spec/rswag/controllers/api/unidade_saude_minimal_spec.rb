# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude_minimal', type: :request do

  path '/api/unidade_saude/listagem/minimal' do

    get('listagem_reduzida unidade_saude_minimal') do
      tags 'Unidade Saude'
      produces 'application/json'
      parameter name: :situacao, in: :query, type: :string, description: 'Situação da unidade de saúde'
      parameter name: :status, in: :query, type: :string, description: 'Status da unidade de saúde'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'
      parameter name: :cnes, in: :query, type: :string, description: 'CNES da unidade de saúde'
      parameter name: :page, in: :query, type: :integer, description: 'Página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Itens por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :exportacao_esus, in: :query, type: :string, description: 'Exportação para o e-SUS'
      description 'Listagem reduzida de unidades de saúde'
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
