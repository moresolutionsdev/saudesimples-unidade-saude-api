# frozen_string_literal: true

class InstalacaoUnidadeSaudeRepository < ApplicationRepository
  def self.create!(unidade_saude_id, instalacao_fisica_id, qtde_instalacoes, qtde_leitos)
    InstalacaoUnidadeSaude.create!(
      unidade_saude_id:,
      instalacao_fisica_id:,
      qtde_instalacoes:,
      qtde_leitos:
    )
  end

  def self.destroy!(id)
    InstalacaoUnidadeSaude.find(id).destroy!
  end
end
