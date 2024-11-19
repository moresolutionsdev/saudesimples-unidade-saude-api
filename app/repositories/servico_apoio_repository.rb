# frozen_string_literal: true

class ServicoApoioRepository < ApplicationRepository
  class << self
    delegate_missing_to ServicoApoio
  end
end
