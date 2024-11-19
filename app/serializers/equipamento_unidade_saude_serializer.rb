# frozen_string_literal: true

class EquipamentoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :unidade_saude_id, :equipamento_id, :tipo_equipamento_id
  fields :qtde_existente, :qtde_em_uso, :disponivel_para_sus, :tipo_equipamento

  field :actions do |equipamento_unidade_saude, options|
    user = options[:current_user]
    authorization_service = AuthorizationService.new(user, equipamento_unidade_saude.unidade_saude)
    {
      delete: authorization_service.permissions[:delete_equipamento]
    }
  end

  field :equipamento do |equipamento_unidade_saude|
    equipamento = equipamento_unidade_saude.equipamento
    equipamento ? { nome: equipamento.nome.upcase, id: equipamento.id, codigo: equipamento.codigo } : nil
  end

  view :extended do
    association :equipamento, blueprint: ::EquipamentoSerializer, view: :normal
    association :tipo_equipamento, blueprint: ::TipoEquipamentoSerializer, view: :normal
  end
end
