# frozen_string_literal: true

Carrots.configure do |config|
  config.app_name = 'unidade-saude-api'
  config.rabbitmq_url = ENV['RABBITMQ_URL']
end
