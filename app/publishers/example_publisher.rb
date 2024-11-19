# frozen_string_literal: true

class ExamplePublisher < ApplicationPublisher
  EXAMPLE_DATA = { id: 1, description: 'Example of data to be published' }.freeze

  def initialize(data = EXAMPLE_DATA)
    @data = data
  end

  def call
    Carrots::Publisher.call(
      exchange: 'undidade-saude-api.example-exchange',
      type: 'fanout',
      message: message_body
    )
  end

  private

  def message_body
    {
      id: @data[:id],
      description: @data[:description],
      date: Time.zone.now
    }
  end
end
