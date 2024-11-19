# frozen_string_literal: true

class PaisRepository < ApplicationRepository
  class << self
    delegate_missing_to Pais
  end
end
