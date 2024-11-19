# frozen_string_literal: true

namespace :rswag do
  namespace :custom do
    desc 'Generate Swagger docs for specific patterns'
    task swaggerize: :environment do
      ENV['PATTERN'] = 'spec/rswag/controllers/api/**/*_spec.rb'
      ENV['INCLUDE_RSWAG'] = 'true'

      # Run the rswag task
      Rake::Task['rswag:specs:swaggerize'].invoke
    end
  end
end
