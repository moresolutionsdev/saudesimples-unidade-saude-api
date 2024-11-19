# frozen_string_literal: true

class TipoBloqueioRepository < ApplicationRepository
  class << self
    delegate_missing_to TipoBloqueio
  end
end
