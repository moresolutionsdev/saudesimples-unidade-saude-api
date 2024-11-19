# frozen_string_literal: true

class BuscaEquipeSerializer < ApplicationSerializer
  identifier :id

  fields :codigo,
         :nome,
         :area,
         :data_ativacao,
         :data_desativacao,
         :motivo_desativacao,
         :populacao_assistida

  association :categoria_equipe, blueprint: CategoriaEquipeSerializer
  association :tipo_equipe, blueprint: TipoEquipeSerializer

  field :cnes_equipe do |equipe|
    {
      id: equipe.unidade_saude&.id,
      codigo: equipe.unidade_saude&.codigo_cnes,
      nome: equipe.unidade_saude&.nome
    }
  end

  field :actions do |equipe, options|
    user = options[:current_user]
    authorization_service = AuthorizationService.new(user, equipe.unidade_saude)

    permissions = authorization_service.permissions[:equipe] || {}

    {
      edit: permissions[:edit] || false,
      delete: permissions[:delete] || false,
      show: permissions[:show] || false
    }
  end
end
