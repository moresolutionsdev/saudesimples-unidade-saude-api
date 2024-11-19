# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/importacao_zip/webhook', type: :request do
  path '/api/unidade_saude/importacao_zip/sync_unidades_saude' do
    post('sync_unidades_saude webhook') do
      tags 'Importação CNES'
      description 'Webhook para sincronizar as unidades de saude. Perfoma um job para sincronizar as unidades de saude (SyncUnidadesDeSaudeWithCNESJob)'
      consumes 'application/json'
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
