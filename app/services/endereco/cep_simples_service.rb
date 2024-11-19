# frozen_string_literal: true

module Endereco
  class CepSimplesService < ApplicationService
    include HttpClient

    BASE_URL = Rails.configuration.env_params.cep_simples_api_url
    API_KEY = Rails.configuration.env_params.cep_simples_api_key

    def call(cep:)
      data = fetch_cep_simples(cep)

      {
        success: true,
        data:
      }
    end

    private

    def fetch_cep_simples(cep)
      parse_json(
        get(
          url: "#{BASE_URL}/v1/ceps/#{cep}",
          headers: {
            'Accept' => '*/*',
            'api-key' => API_KEY
          }
        )
      )
    end
  end
end
