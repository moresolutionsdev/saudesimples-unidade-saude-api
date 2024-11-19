# frozen_string_literal: true

class UnidadeSaudeOcupacaoSerializer < ApplicationSerializer
  identifier :id

  view :normal do
    association :ocupacao, blueprint: OcupacaoSerializer
  end

  view :listagem_agenda do
    association :unidade_saude, blueprint: UnidadeSaudeSerializer, view: :listagem_agenda
    association :ocupacao, blueprint: OcupacaoSerializer
  end
end
