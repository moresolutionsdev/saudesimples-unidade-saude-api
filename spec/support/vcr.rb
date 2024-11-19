# frozen_string_literal: true

require 'vcr'
require 'webmock'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # This configuration block is used to filter sensitive data from the HTTP interactions
  # that VCR records. In this case, it's filtering out the 'token' from the
  # request headers.
  #
  # @param interaction [VCR::HTTPInteraction] The HTTP interaction to be recorded.
  #
  # @return [String] The 'token' if the request headers contain an 'Authorization' field,
  #   otherwise nil.
  config.filter_sensitive_data('<token>') do |interaction|
    interaction.request.headers['Authorization']&.first
  end

  # This configuration block is used to filter sensitive data from the HTTP interactions
  # that VCR records. In this case, it's filtering out the 'client_secret' from the
  # request body.
  #
  # @param interaction [VCR::HTTPInteraction] The HTTP interaction to be recorded.
  #
  # @return [String] The 'client_secret' if the request body is a Hash and contains
  #   a 'client_secret', otherwise nil.
  config.filter_sensitive_data('<client_secret>') do |interaction|
    # precisei comentar a linha por conta do seguinte erro:
    # Rack::QueryParser::InvalidParameterError:]
    # Rack::Utils.parse_nested_query(interaction.request.body)['client_secret']
  end

  # This configuration block is used to filter sensitive data from the HTTP interactions
  # that VCR records. In this case, it's filtering out the 'access_token' from the
  # response body.
  #
  # @param interaction [VCR::HTTPInteraction] The HTTP interaction to be recorded.
  #
  # @return [String] The 'access_token' if the response body is a Hash and contains
  #   an 'access_token', otherwise an empty string.
  config.filter_sensitive_data('<access_token>') do |interaction|
    # Parse the response body as JSON. If the parsing fails, a JSON::ParserError is
    # raised and caught, returning an empty string.
    parsed_response = JSON.parse!(interaction.response.body)

    # If the parsed response is a Hash, return the 'access_token', otherwise return
    # an empty string.
    parsed_response['access_token'] if parsed_response.is_a?(Hash)
  rescue JSON::ParserError
    # If a JSON::ParserError is raised when parsing the response body, return an
    # empty string.
    ''
  end

  # This block is executed before each request is recorded by VCR.
  # It modifies both the request and response parts of the HTTP interaction.
  #
  # @param holder [VCR::HTTPInteraction] The HTTP interaction to be recorded.
  # @yieldparam holder [VCR::HTTPInteraction] The HTTP interaction to be recorded.
  # @yieldreturn [VCR::HTTPInteraction] The modified HTTP interaction.
  config.before_record do |holder|
    # Force the encoding of the response body to UTF-8.
    holder.response.body.force_encoding('UTF-8')

    # Set the Authorization header of the request to 'Bearer token' if it's not already set.
    holder.request.headers['Authorization'] = ['Bearer token'] unless holder.request.headers['Authorization'].nil?

    # Set some headers on the response.
    holder.response.headers['Access-Control-Expose-Headers'] = ['access-control-expose-headers']
    holder.response.headers['Etag'] = ['etag']
    holder.response.headers['X-Request-Id'] = ['x-request-id']

    # If the response body contains a 'token' and the request URI includes 'access_tokens',
    # replace the 'token' in the response body with 'token'.
    if holder.response.body['token'].present? && holder.request.uri.include?('access_tokens')
      content = JSON.parse(holder.response.body)
      content['token'] = 'token'
      holder.response.body = content.to_json
    end

    # Return the modified HTTP interaction.
    holder
  end
end
