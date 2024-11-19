# frozen_string_literal: true

class ServicoRepository < ApplicationRepository
  def self.all
    Servico.all
  end
end
