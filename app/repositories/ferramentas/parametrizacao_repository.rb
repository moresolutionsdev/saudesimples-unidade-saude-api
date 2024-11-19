# frozen_string_literal: true

module Ferramentas
  class ParametrizacaoRepository < ApplicationRepository
    class << self
      delegate_missing_to Ferramentas::Parametrizacao
    end
  end
end
