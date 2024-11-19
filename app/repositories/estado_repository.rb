# frozen_string_literal: true

class EstadoRepository < ApplicationRepository
  class << self
    delegate_missing_to Estado

    def all
      order(nome: :asc)
    end
  end
end
