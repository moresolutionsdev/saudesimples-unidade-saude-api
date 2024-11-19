# frozen_string_literal: true

module SigtapApi
  class SigtapRepository < ApplicationRepository
    BASE_URL = Rails.configuration.env_params.integracao_sigtap_api_url

    class << self
      def lista_ocupacoes(params = {})
        url = "#{BASE_URL}/api/v1/ocupacoes"
        payload = params.slice(:page, :per_page)

        parse_json(get(url:, payload:))
      end
    end
  end
end
