# frozen_string_literal: true

class UnidadeSaudeParametrosRepository < ApplicationRepository
  class << self
    delegate_missing_to :unidade_saude

    def find_parametros_by_id(unidade_saude_id)
      unidade_saude
        .select(:exportacao_esus, :validacao_municipe)
        .find_by(id: unidade_saude_id)
    end
  end

  def self.unidade_saude
    UnidadeSaude
  end
end
