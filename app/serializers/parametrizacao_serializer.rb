# frozen_string_literal: true

class ParametrizacaoSerializer < ApplicationSerializer
  identifier :id

  field :logo_url do |parametrizacao|
    parametrizacao.logo_url
  rescue StandardError => e
    Rails.logger.error(e)
    nil
  end
end
