# frozen_string_literal: true

require 'factory_bot_rails'

FactoryBot.definition_file_paths = [
  Saudesimples::Core::Engine.root.join('spec', 'factories').to_s,
  Rails.root.join('spec/factories').to_s
]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
