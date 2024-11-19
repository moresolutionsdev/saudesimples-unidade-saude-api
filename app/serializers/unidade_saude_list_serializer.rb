# frozen_string_literal: true

class UnidadeSaudeListSerializer < ApplicationSerializer
  identifier :id

  fields :cpf_numero, :cnpj_numero, :nome, :codigo_cnes, :status, :tipo_unidade

  field :actions do |unit, options|
    user = options[:current_user]
    authorization_service = AuthorizationService.new(user, unit)
    authorization_service.permissions
  end

  field :status do |resource, _options|
    if resource.inativa
      'Inativa'
    else
      'Ativa'
    end
  end

  view :extended do
    association :tipo_unidade, blueprint: TipoUnidadeSaudeSerializer, view: :normal
  end
end
