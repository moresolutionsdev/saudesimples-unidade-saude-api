# frozen_string_literal: true

module Serializable
  extend ActiveSupport::Concern

  included do
    def serialize(object, serializer, options = {})
      serializer.render_as_hash(object, context_options.merge(options))
    end

    def serialize_as_json(object, serializer, options = {})
      serializer.render_as_json(object, context_options.merge(options))
    end

    private

    # rubocop:disable Style/RescueModifier
    def context_options
      {
        current_user: (current_user rescue nil),
        permissions: (permissions rescue {})
      }
    end
    # rubocop:enable Style/RescueModifier
  end
end
