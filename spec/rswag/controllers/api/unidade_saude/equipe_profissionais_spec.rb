# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/equipe_profissionais', type: :request do
  path '/api/unidade_saude/profissionais/{profissional_id}/equipes' do
    # You'll want to customize the parameter types...
    parameter name: 'profissional_id', in: :path, type: :string, description: 'profissional_id'

    get('by_profissional equipe_profissionai') do
      tags 'Equipe Profissionais'
      description 'Listar as equipes de um profissional'
      produces 'application/json'

      response(200, 'successful') do
        let(:profissional_id) { '123' }

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

  path '/api/unidade_saude/{unidade_saude_id}/equipes/{equipe_id}/equipe_profissionais' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'equipe_id', in: :path, type: :string, description: 'equipe_id'

    get('list equipe_profissionais') do
      tags 'Equipe Profissionais'
      description 'Listar os profissionais de uma equipe'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }
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
