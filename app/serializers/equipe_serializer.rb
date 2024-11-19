# frozen_string_literal: true

class EquipeSerializer < ApplicationSerializer
  identifier :id

  fields :codigo,
         :nome,
         :area,
         :data_ativacao,
         :data_desativacao,
         :motivo_desativacao,
         :populacao_assistida

  association :unidade_saude, blueprint: UnidadeSaudeListaReduzidaSerializer
  association :categoria_equipe, blueprint: CategoriaEquipeSerializer
  association :tipo_equipe, blueprint: TipoEquipeSerializer
  association :mapeamento_indigena, blueprint: MapeamentoIndigenaSerializer
end
