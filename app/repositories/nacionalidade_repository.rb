# frozen_string_literal: true

class NacionalidadeRepository < ApplicationRepository
  class << self
    delegate_missing_to Nacionalidade
  end
end
