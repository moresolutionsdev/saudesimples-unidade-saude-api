# frozen_string_literal: true

module HttpClient
  # Sends an HTTP GET request.
  #
  # @param url [String] The URL to send the request to.
  # @param payload [Hash] Optional payload for the request.
  # @param headers [Hash] Optional headers for the request.
  # @return [Faraday::Response] The HTTP response.
  def get(url:, payload: {}, headers: {})
    request(method: :get, url:, payload:, headers:)
  end

  # Sends an HTTP POST request.
  #
  # @param url [String] The URL to send the request to.
  # @param payload [Hash] Optional payload for the request.
  # @param headers [Hash] Optional headers for the request.
  # @return [Faraday::Response] The HTTP response.
  def post(url:, payload: {}, headers: {})
    request(method: :post, url:, payload:, headers:)
  end

  # Sends an HTTP PUT request.
  #
  # @param url [String] The URL to send the request to.
  # @param payload [Hash] Optional payload for the request.
  # @param headers [Hash] Optional headers for the request.
  # @return [Faraday::Response] The HTTP response.
  def put(url:, payload: {}, headers: {})
    request(method: :put, url:, payload:, headers:)
  end

  # Sends an HTTP PATCH request.
  #
  # @param url [String] The URL to send the request to.
  # @param payload [Hash] Optional payload for the request.
  # @param headers [Hash] Optional headers for the request.
  # @return [Faraday::Response] The HTTP response.
  def patch(url:, payload: {}, headers: {})
    request(method: :patch, url:, payload:, headers:)
  end

  # Sends an HTTP DELETE request.
  #
  # @param url [String] The URL to send the request to.
  # @param payload [Hash] Optional payload for the request.
  # @param headers [Hash] Optional headers for the request.
  # @return [Faraday::Response] The HTTP response.
  def delete(url:, payload: {}, headers: {})
    request(method: :delete, url:, payload:, headers:)
  end

  # Parses a JSON response.
  #
  # @param response [Object] The response object to parse. Expected to respond to `#body` with a JSON string.
  # @return [Hash] The parsed JSON response, with keys as symbols.
  def parse_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def request(method:, url:, payload: {}, headers: {})
    params = %i[get delete head].include?(method) ? payload : {}
    body = %i[post put patch].include?(method) ? payload.to_json : nil

    http_client(
      url:,
      params:,
      headers: default_headers.merge(headers)
    ).send(method) do |req|
      req.body = body if body
    end
  end

  def default_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def http_client(url:, headers:, params:)
    Faraday.new(url:, headers:, params:) do |conn|
      conn.use Faraday::Response::RaiseError
      conn.request :retry, retry_options
      conn.response :logger, Rails.logger, headers: true, bodies: true, log_level: :debug
      conn.adapter Faraday.default_adapter
    end
  end

  def retry_options
    {
      max: 3,
      interval: 0.05,
      interval_randomness: 0.5,
      methods: [:get]
    }
  end
end
