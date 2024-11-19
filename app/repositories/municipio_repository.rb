# frozen_string_literal: true

class MunicipioRepository < ApplicationRepository
  class << self
    delegate_missing_to Municipio
  end
end
