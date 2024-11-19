# frozen_string_literal: true

class UnidadeSaudeOcupacaoRepository < ApplicationRepository
  class << self
    delegate_missing_to UnidadeSaudeOcupacao
  end
end
