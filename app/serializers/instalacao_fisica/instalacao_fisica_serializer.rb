# frozen_string_literal: true

# app/blueprints/instalacao_fisica/instalacao_fisica_blueprint.rb
class InstalacaoFisica
  class InstalacaoFisicaSerializer < ApplicationSerializer
    identifier :id

    fields :id, :nome, :codigo

    association :subtipo_instalacao, blueprint: InstalacaoFisica::SubtipoInstalacaoSerializer
    association :tipo_instalacao_fisica, blueprint: InstalacaoFisica::TipoInstalacaoFisicaSerializer
  end
end
