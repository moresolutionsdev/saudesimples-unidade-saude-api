# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/unidade_saude/politicas_acesso', type: :request do
  path '/api/unidade_saude/politicas_acesso/ultima_versao' do
    get('ultima_versao politicas_acesso') do
      tags 'Politicas de Acesso'
      description 'Listar a ultima versão das politicas de acesso'
      produces 'application/json'

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

  path '/api/unidade_saude/politicas_acesso' do
    get('list politicas_acessos') do
      tags 'Politicas de Acesso'
      description 'Listar as politicas de acesso'
      produces 'application/json'
      parameter name: :nome_arquivo, in: :query, type: :string, description: 'Nome do arquivo'
      parameter name: :data_criacao, in: :query, type: :string, description: 'Data de criação'
      parameter name: :email_usuario, in: :query, type: :string, description: 'Email do usuário'
      parameter name: :order, in: :query, type: :string, description: 'Ordenação dos registros'
      parameter name: :order_direction, in: :query, type: :string, description: 'Direção da ordenação'
      parameter name: :page, in: :query, type: :string, description: 'Número da página'
      parameter name: :per_page, in: :query, type: :string, description: 'Número de registros por página'

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

    post('create politicas_acesso') do
      tags 'Politicas de Acesso'
      description 'Criar uma politica de acesso'
      consumes 'application/json'
      parameter name: :documento_arquivo, in: :formData, type: :file, description: 'Arquivo do documento'
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

  path '/api/unidade_saude/politicas_acesso/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show politicas_acesso') do
      tags 'Politicas de Acesso'
      description 'Exibir uma politica de acesso'
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
