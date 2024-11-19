# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/tipo_equipes', type: :request do
  path '/api/tipo_equipes' do
    get('list tipo_equipes') do
      tags 'Equipes'
      produces 'application/json'
      parameter name: :sigla, in: :query, type: :string, description: 'Sigla da equipe'
      parameter name: :descricao, in: :query, type: :string, description: 'Descrição da equipe'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      description 'Listagem de tipo de equipes'
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
