# frozen_string_literal: true

class EquipamentoUtilizavelSerializer < ApplicationSerializer
  fields :id, :nome, :fabricante, :numero_serie

  association :equipamento, blueprint: EquipamentoSerializer
  association :tipo_equipamento, blueprint: TipoEquipamentoSerializer

  view :listagem_agenda do
    fields :id, :nome, :fabricante, :numero_serie

    association :equipamento, blueprint: EquipamentoSerializer, view: :listagem_agenda
    association :tipo_equipamento, blueprint: TipoEquipamentoSerializer
  end
end
