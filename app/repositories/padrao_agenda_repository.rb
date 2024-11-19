# frozen_string_literal: true

class PadraoAgendaRepository < ApplicationRepository
  class << self
    delegate_missing_to PadraoAgenda

    def all
      order(nome: :asc)
    end
  end
end
