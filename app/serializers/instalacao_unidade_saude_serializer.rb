# frozen_string_literal: true

class InstalacaoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :id, :unidade_saude_id, :qtde_instalacoes, :qtde_leitos

  view :normal do
    fields :id, :unidade_saude_id, :qtde_instalacoes, :qtde_leitos
    association :instalacao_fisica, blueprint: InstalacaoFisica::InstalacaoFisicaSerializer
  end

  view :extended do
    include_view :normal
    field :actions do |unit, options|
      user = options[:current_user]
      authorization_service = AuthorizationService.new(user, unit.unidade_saude)
      {
        delete: authorization_service.permissions[:instalacao_unidades] || false
      }
    end
  end
end
