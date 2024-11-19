# frozen_string_literal: true

class ServicosClassificacaoSerializer < ApplicationSerializer
  identifier :id
  fields :codigo_servico, :codigo_classificacao, :classificacao
  field :nome do |unit, _options|
    unit.classificacao
  end
end
