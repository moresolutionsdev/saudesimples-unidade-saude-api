# frozen_string_literal: true

class CnaesRepository < ApplicationRepository
  def self.all_cnaes
    Cnae.select(:id, :codigo, :nome)
  end
end
