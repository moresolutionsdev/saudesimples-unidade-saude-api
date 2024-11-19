# frozen_string_literal: true

class ExampleConsumer
  include SneakersConsumer

  listen_queue('example-app.example-queue')

  def perform(message)
    # Your code here
    Rails.logger.info("Received message: #{message}")
  end
end
