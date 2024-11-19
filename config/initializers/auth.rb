# frozen_string_literal: true

AutenticacaoGem.configure do |config|
  config.auth_api_base_url = Rails.configuration.env_params.saude_simples_auth_api_base_url
end


