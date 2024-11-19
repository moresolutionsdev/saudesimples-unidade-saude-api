# frozen_string_literal: true

class SyncElasticsearchJob < ApplicationJob
  queue_as :default

  def perform(args)
    document = fetch_document(args[:id])
    index_document(document)
  end

  private

  def fetch_document(id)
    UnidadeSaude.find(id).as_indexed_json
  end

  def index_document(document)
    document_url = "#{elasticsearch_url}/unidade_saude/_doc/#{document[:id]}"
    response = Faraday.post(document_url, document.to_json, content_type: 'application/json')

    return if response.success?

    raise "Failed to index document: #{response.body}"
  end

  def elasticsearch_url
    ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'
  end
end
