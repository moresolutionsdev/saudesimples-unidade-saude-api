# frozen_string_literal: true

class SubtipoUnidadeSaudeRepository < ApplicationRepository
  def self.search_by_classificacao(classificacao_cnes_id)
    SubtipoUnidadeSaude.joins(:classificacao_cnes, :descricao_subtipo_unidade)
      .where(classificacao_cnes_id:)
      .select('descricao_subtipo_unidades.*')
  end
end
