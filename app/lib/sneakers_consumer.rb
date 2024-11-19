# frozen_string_literal: true

module SneakersConsumer
  def self.included(base)
    base.include Sneakers::Worker
    base.extend ClassMethods
  end

  def work_with_params(message, delivery_info, metadata)
    log('Starting ', metadata, delivery_info)

    ActiveRecord::Base.connection_pool.with_connection do
      perform(message)
    end

    log('Done ', metadata, delivery_info)

    ack!
  rescue StandardError => e # rubocop:disable Lint/UselessRescue
    # Do something with the error here (e.g. log it or send it to Sentry)
    raise e
  end

  module ClassMethods
    def listen_queue(queue_name, opts = {})
      default_options = {
        arguments: { 'x-dead-letter-exchange' => "#{queue_name}-retry" }
      }
      from_queue(
        queue_name,
        default_options.merge(opts)
      )
    end
  end

  private

  def log(prefix, metadata, delivery_info)
    logger = Rails.logger

    logger.tagged('RABBITMQ') do
      logger.info(
        "#{prefix} " \
        "[#{metadata[:message_id]}]-[#{delivery_info[:consumer].queue.name}]"
      )
    end
  end
end
