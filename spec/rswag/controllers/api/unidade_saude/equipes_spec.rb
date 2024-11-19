# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/equipes', type: :request do
  path '/api/unidade_saude/equipes/minimal' do
    get('minimal equipe') do
      tags 'Equipes'
      produces 'application/json'
      description 'Listagem de equipes'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :integer, description: 'Número de registros por página'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'

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

  path '/api/unidade_saude/equipes/{id}/micro_areas' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('micro_areas equipe') do
      tags ['Equipes', 'Micro Áreas']
      description 'Listar as micro áreas de uma equipe'
      produces 'application/json'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'

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

  path '/api/unidade_saude/{unidade_saude_id}/equipes' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'

    get('list equipes') do
      tags 'Equipes'
      description 'Listar as equipes de uma unidade de saude'
      produces 'application/json'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :term, in: :query, type: :string, description: 'Termo de busca'

      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }

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

  path '/api/unidade_saude/{unidade_saude_id}/equipes/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show equipe') do
      tags 'Equipes'
      description 'Exibir uma equipe de uma unidade de saude'
      produces 'application/json'
      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }
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
