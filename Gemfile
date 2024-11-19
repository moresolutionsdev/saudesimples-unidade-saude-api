# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'

source 'https://rubygems.pkg.github.com/om30' do
  gem 'autenticacao-gem', '>= 1.0.3', require: 'autenticacao_gem'
  gem 'carrots', '>= 0.1.1'
  gem 'saudesimples-core', '>= 1.46.0'

  # === Versão local ===
  # gem 'autenticacao-gem', path: '../autenticacao-gem', require: 'autenticacao_gem'
  # gem 'saudesimples-core', path: '../saudesimples-core'
end

gem 'blueprinter', '~> 1.0', '>= 1.0.2'
gem 'bootsnap', require: false
gem 'bundler-audit', '~> 0.9.1'
gem 'google-cloud-storage', '~> 1.52'
gem 'newrelic_rpm'
gem 'opentelemetry-exporter-otlp', '~> 0.26.3'
gem 'opentelemetry-instrumentation-all', '~> 0.60.0'
gem 'opentelemetry-sdk', '~> 1.4', '>= 1.4.1'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rack-cors', '~> 2.0', '>= 2.0.2'
gem 'rails', '~> 7.1.3', '>= 7.1.3.3'
gem 'redis', '~> 5.2'
gem 'rswag-api'
gem 'rswag-ui'
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'sidekiq-cron'
gem 'sneakers', '~> 2.12'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'colorize', '~> 1.1'
  gem 'debug'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.3', '>= 3.3.1'
  gem 'pry', '~> 0.14.2'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
  gem 'rswag-specs'
  gem 'shoulda-matchers'
  gem 'simplecov', '~> 0.22.0'
  gem 'simplecov-console', '~> 0.9.1'
  gem 'vcr', '>= 6.2'
  gem 'webmock', '>= 3.23'
end

group :development do
  gem 'brakeman', '~> 6.1', '>= 6.1.2'
  gem 'bullet', '~> 7.1', '>= 7.1.6'
  gem 'rails-erd', '~> 1.7', '>= 1.7.2'
  gem 'reek', '~> 6.3'
  gem 'rubocop', '~> 1.64'
  gem 'rubocop-performance', '~> 1.21'
  gem 'rubocop-rails', '~> 2.25'
  gem 'rubocop-rspec', '~> 2.29', '>= 2.29.2'
  gem 'traceroute', '~> 0.8.1'
end

group :development, :test, :staging do
  gem 'dotenv', '~> 3.1', '>= 3.1.2'
end
