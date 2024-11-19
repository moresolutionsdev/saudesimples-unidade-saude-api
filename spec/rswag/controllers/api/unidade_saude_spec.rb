# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'api/unidade_saude', type: :request do
  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }
  end

  path '/api/unidade_saude/tipo_administracao' do
    get('tipo_administracao unidade_saude') do
      tags 'Unidade Saude'
      description 'Retorna os tipos de administração de uma unidade de saúde'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/subtipo_unidade_saude' do
    get('subtipo_unidade_saude unidade_saude') do
      tags 'Unidade Saude'
      description 'Retorna os subtipos de uma unidade de saúde'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/tipo_logradouro' do
    get('tipo_logradouro unidade_saude') do
      tags 'Endereço'
      description 'Retorna os tipos de logradouro'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/estados_habilitados' do
    get('estados_habilitados unidade_saude') do
      tags 'Endereço'
      description 'Retorna os estados habilitados para cadastro'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/busca_cep/{cep}' do
    # You'll want to customize the parameter types...
    parameter name: 'cep', in: :path, type: :string, description: 'cep'

    get('busca_cep unidade_saude') do
      tags 'Endereço'
      description 'Retorna o endereço referente ao cep informado'
      response(200, 'successful') do
        let(:cep) { '123' }

        run_test!
      end
    end
  end

  path '/api/unidade_saude/local' do
    get('local unidade_saude') do
      tags 'Unidade Saude'
      description 'Retorna os locais de atendimento de uma unidade de saúde'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/municipio/{municipio_id}' do
    # You'll want to customize the parameter types...
    parameter name: 'municipio_id', in: :path, type: :string, description: 'municipio_id'

    get('municipio unidade_saude') do
      tags 'Endereço'
      description 'Retorna o município referente ao id informado'
      response(200, 'successful') do
        let(:municipio_id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{id}/servico_especializado' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('servico_especializado unidade_saude') do
      tags 'Serviço Especializado'
      description 'Retorna os serviços especializados de uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{id}/equipamento' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('unidade_saude_equipamentos unidade_saude') do
      tags 'Equipamento'
      description 'Retorna os equipamentos de uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end

    post('create_unidade_saude_equipamento unidade_saude') do
      tags 'Equipamento'
      description 'Cria um equipamento para uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{id}/endereco_complementar' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('endereco_complementar unidade_saude') do
      tags 'Endereço'
      description 'Retorna o endereço complementar de uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{id}/profissional_cadastrado' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('profissional_cadastrado unidade_saude') do
      tags 'Profissional Cadastrado'
      description 'Retorna os profissionais cadastrados de uma unidade de saúde'

      parameter name: :unidade_saude, in: :query, type: :string, description: 'unidade_saude'
      parameter name: :page, in: :query, type: :integer, description: 'page'
      parameter name: :per_page, in: :query, type: :integer, description: 'per_page'
      parameter name: :order, in: :query, type: :string, description: 'order'
      parameter name: :order_direction, in: :query, type: :string, description: 'order_direction'
      parameter name: :nome, in: :query, type: :string, description: 'nome'
      parameter name: :ocupacao_id, in: :query, type: :string, description: 'ocupacao_id'
      parameter name: :ocupacao_nome, in: :query, type: :string, description: 'ocupacao_nome'
      parameter name: :id, in: :query, type: :string, description: 'id'

      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude' do
    get('list unidade_saudes') do
      tags 'Unidade Saude'
      description 'Retorna uma lista de unidades de saúde'

      parameter name: :page, in: :query, type: :integer, description: 'page'
      parameter name: :per_page, in: :query, type: :integer, description: 'per_page'
      parameter name: :term, in: :query, type: :string, description: 'term'
      parameter name: :situation, in: :query, type: :string, description: 'situacao'
      parameter name: :status, in: :query, type: :string, description: 'status'
      parameter name: :cnes, in: :query, type: :string, description: 'cnes'
      parameter name: :order, in: :query, type: :string, description: 'order'
      parameter name: :order_direction, in: :query, type: :string, description: 'order_direction'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create unidade_saude') do
      tags 'Unidade Saude'
      description 'Cria uma unidade de saúde'
      parameter name: :unidade_saude, in: :body, schema: {
        type: :object,
        properties: {
          codigo_cnes: { type: :string },
          classificacao_cnes_id: { type: :string },
          cnpj_numero: { type: :string },
          cpf_numero: { type: :string },
          tipo_pessoa_cnes_id: { type: :string },
          situacao_unidade_saude_id: { type: :string },
          descricao_subtipo_unidade_id: { type: :string },
          razao_social: { type: :string },
          cep: { type: :string },
          estado_id: { type: :string },
          municipio_id: { type: :string },
          tipo_logradouro_id: { type: :string },
          logradouro: { type: :string },
          numero: { type: :string },
          bairro: { type: :string },
          ibge: { type: :string },
          nome: { type: :string },
          tipo_unidade_id: { type: :string },
          local_id: { type: :string },
          complemento: { type: :string },
          telefone: { type: :string },
          email: { type: :string },
          url: { type: :string },
          administrador_id: { type: :string },
          horarios_funcionamento: {
            type: :array,
            items: {
              type: :object,
              properties: {
                dia_semana: { type: :string },
                horario_inicio: { type: :string },
                horario_encerramento: { type: :string }
              }
            }
          },
          mantenedora: {
            type: :object,
            properties: {
              nome: { type: :string },
              cnpj_numero: { type: :string },
              cep: { type: :string },
              estado_id: { type: :string },
              municipio_id: { type: :string },
              tipo_logradouro_id: { type: :string },
              logradouro: { type: :string },
              numero: { type: :string },
              bairro: { type: :string },
              complemento: { type: :string },
              codigo_regiao_saude: { type: :string },
              telefone: { type: :string },
              agencia: { type: :string },
              conta_corrente: { type: :string }
            }
          }
        }
      }

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show unidade_saude') do
      tags 'Unidade Saude'
      description 'Retorna uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end

    put('update unidade_saude') do
      tags 'Unidade Saude'
      description 'Atualiza uma unidade de saúde'
      parameter name: :unidade_saude, in: :body, schema: {
        type: :object,
        properties: {
          codigo_cnes: { type: :string },
          classificacao_cnes_id: { type: :string },
          cnpj_numero: { type: :string },
          cpf_numero: { type: :string },
          tipo_pessoa_cnes_id: { type: :string },
          situacao_unidade_saude_id: { type: :string },
          descricao_subtipo_unidade_id: { type: :string },
          razao_social: { type: :string },
          cep: { type: :string },
          estado_id: { type: :string },
          municipio_id: { type: :string },
          tipo_logradouro_id: { type: :string },
          logradouro: { type: :string },
          numero: { type: :string },
          bairro: { type: :string },
          ibge: { type: :string },
          nome: { type: :string },
          tipo_unidade_id: { type: :string },
          local_id: { type: :string },
          complemento: { type: :string },
          telefone: { type: :string },
          email: { type: :string },
          url: { type: :string },
          administrador_id: { type: :string },
          horarios_funcionamento: {
            type: :array,
            items: {
              type: :object,
              properties: {
                dia_semana: { type: :string },
                horario_inicio: { type: :string },
                horario_encerramento: { type: :string }
              }
            }
          },
          mantenedora: {
            type: :object,
            properties: {
              nome: { type: :string },
              cnpj_numero: { type: :string },
              cep: { type: :string },
              estado_id: { type: :string },
              municipio_id: { type: :string },
              tipo_logradouro_id: { type: :string },
              logradouro: { type: :string },
              numero: { type: :string },
              bairro: { type: :string },
              complemento: { type: :string },
              codigo_regiao_saude: { type: :string },
              telefone: { type: :string },
              agencia: { type: :string },
              conta_corrente: { type: :string }
            }
          }
        }
      }
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end

    delete('delete unidade_saude') do
      tags 'Unidade Saude'
      description 'Faz uma exclusão lógica de uma unidade de saúde'
      response(200, 'successful') do
        let(:id) { '123' }
        run_test!
      end
    end
  end

  path '/api/unidade_saude/{unidade_saude_id}/equipamento/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'unidade_saude_id', in: :path, type: :string, description: 'unidade_saude_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    delete('delete_unidade_saude_equipamentos unidade_saude') do
      tags 'Equipamento'
      description 'Deleta um equipamento de uma unidade de saúde'
      response(200, 'successful') do
        let(:unidade_saude_id) { '123' }
        let(:id) { '123' }
        run_test!
      end
    end
  end
end
