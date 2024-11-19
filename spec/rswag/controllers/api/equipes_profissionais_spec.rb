# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/equipes_profissionais', type: :request do
  path '/api/unidade_saude/equipes/{equipe_id}/equipe_profissionais' do
    # You'll want to customize the parameter types...
    parameter name: 'equipe_id', in: :path, type: :string, description: 'equipe_id'

    get('list equipes_profissionais') do
      tags 'Equipes Profissionais'
      description 'Listar os profissionais de uma equipe'
      produces 'application/json'

      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'

      response(200, 'successful') do
        let(:equipe_id) { '123' }

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
