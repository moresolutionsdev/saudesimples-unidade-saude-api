# frozen_string_literal: true

class DescricaoSubtipoUnidadeRepository
  def self.search_by_classificacao(classificacao_cnes_id)
    if classificacao_cnes_id.present?
      DescricaoSubtipoUnidade.where(classificacao_cnes_id:)
    else
      DescricaoSubtipoUnidade.all
    end
  end
end
