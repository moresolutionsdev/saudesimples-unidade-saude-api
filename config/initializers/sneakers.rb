# frozen_string_literal: true

require 'sneakers/handlers/maxretry'

# Number of per-cpu processes to run
workers = ENV.fetch('SNEAKERS_WORKERS', 2).to_i
# Thread pool size (good to match prefetch)
threads = ENV.fetch('SNEAKERS_THREADS_PER_WORKER', 10).to_i
# Number of messages to prefetch from RabbitMQ (good to match threads)
prefetch = 10

# Register the content type for the messages and set strategies for serialization and deserialization
Sneakers::ContentType.register(
  content_type: 'application/json',
  serializer: ->(message) { JSON.generate(message) },
  deserializer: ->(message) { JSON.parse(message, symbolize_names: true) }
)

# Max retry plugin change content_type to octet-stream so we need to deserialize the received string as json
Sneakers::ContentType.register(
  content_type: 'application/octet-stream',
  serializer: ->(message) { JSON.generate(message) },
  deserializer: ->(message) { JSON.parse(message, symbolize_names: true) }
)

Sneakers.configure(
  connection: Bunny.new(ENV.fetch('RABBITMQ_URL', nil)),
  durable: true,
  env: ENV.fetch('RAILS_ENV', 'development'),
  workers:,
  threads:,
  prefetch:,
  share_threads: true,
  retry_max_times: 5,
  handler: Sneakers::Handlers::Maxretry,
  hooks: {
    before_fork: lambda {
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.connection_pool.disconnect!
        Sneakers.logger.info('Disconnected from ActiveRecord')
      end
    },
    after_fork: lambda {
      ActiveSupport.on_load(:active_record) do
        # By default, the database pool size is set to 5 in the database.yml file. We need to increase this value to be
        # able to handle the number of threads that Sneakers will use.
        config = Rails.application.config.database_configuration[Rails.env]
        pool_size = prefetch + (workers * threads)
        ActiveRecord::Base.establish_connection(config.merge('pool' => pool_size))
        Rails.logger.info("Sneakers has updated the ActiveRecord connection pool size to #{pool_size}")
        Sneakers.logger.info('Connected to ActiveRecord')
      end
    }
  }
)

Sneakers.logger = Rails.logger
Sneakers.logger.level = Logger::INFO
