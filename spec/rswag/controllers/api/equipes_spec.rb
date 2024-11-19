# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/equipes', type: :request do
  path '/api/unidade_saude/equipes/{id}/alternar_situacao' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('alternar_situacao equipe') do
      tags 'Equipes'
      description 'Alternar a situação de uma equipe'
      produces 'application/json'
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

  path '/api/unidade_saude/equipes' do
    post('create equipe') do
      tags 'Equipes'
      description 'Criar uma equipe para uma unidade de saude'
      produces 'application/json'

      parameter name: :equipe, in: :body, schema: {
        type: :object,
        properties: {
          codigo: { type: :string },
          nome: { type: :string },
          area: { type: :string },
          unidade_saude_id: { type: :string },
          tipo_equipe_id: { type: :string },
          data_ativacao: { type: :string },
          data_desativacao: { type: :string },
          motivo_desativacao: { type: :string },
          populacao_assistida: { type: :string },
          mapeamento_indigena_id: { type: :string },
          equipes_profissionais_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                equipe_id: { type: :string },
                profissional_id: { type: :string },
                ocupacao_id: { type: :string },
                codigo_micro_area: { type: :string },
                entrada: { type: :string },
                data_saida: { type: :string },
                _destroy: { type: :string }
              }
            }
          }
        }
      }

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

  path '/api/unidade_saude/equipes/exists' do
    get('exists equipe') do
      tags 'Equipes'
      description 'Verificar se uma equipe existe'
      produces 'application/json'

      parameter name: :codigo, in: :query, type: :string, description: 'codigo'

      response(200, 'successful') do
        let(:codigo) { '123' }

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

  path '/api/unidade_saude/equipes/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show equipe') do
      tags 'Equipes'
      description 'Exibir uma equipe'
      produces 'application/json'

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

    put('update equipe') do
      tags 'Equipes'
      description 'Atualizar uma equipe'
      produces 'application/json'
      parameter name: :equipe, in: :body, schema: {
        type: :object,
        properties: {
          codigo: { type: :string },
          nome: { type: :string },
          area: { type: :string },
          unidade_saude_id: { type: :string },
          tipo_equipe_id: { type: :string },
          data_ativacao: { type: :string },
          data_desativacao: { type: :string },
          motivo_desativacao: { type: :string },
          populacao_assistida: { type: :string },
          mapeamento_indigena_id: { type: :string },
          equipes_profissionais_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :string },
                equipe_id: { type: :string },
                profissional_id: { type: :string },
                ocupacao_id: { type: :string },
                codigo_micro_area: { type: :string },
                entrada: { type: :string },
                data_saida: { type: :string },
                _destroy: { type: :string }
              }
            }
          }
        }
      }

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

    delete('delete equipe') do
      tags 'Equipes'
      description 'Excluir uma equipe'
      produces 'application/json'
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
