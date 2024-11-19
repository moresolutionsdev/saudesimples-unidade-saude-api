# frozen_string_literal: true

class EquipamentoSerializer < ApplicationSerializer
  identifier :id

  view :normal do
    fields :codigo, :tipo_equipamento_id, :nome, :tipo_equipamento
  end

  view :extended do
    include_view :normal
    association :tipo_equipamento, blueprint: ::TipoEquipamentoSerializer
  end

  view :listagem_agenda do
    # não trás o tipo_equipamento_id
    fields :codigo, :nome, :tipo_equipamento
    association :tipo_equipamento, blueprint: ::TipoEquipamentoSerializer
  end
end
