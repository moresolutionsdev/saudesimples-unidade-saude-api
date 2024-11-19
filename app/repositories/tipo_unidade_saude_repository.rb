# frozen_string_literal: true

class TipoUnidadeSaudeRepository < ApplicationRepository
  def self.all
    TipoUnidade.all
  end
end
