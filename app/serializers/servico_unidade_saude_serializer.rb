# frozen_string_literal: true

class ServicoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :id, :codigo_classificacao, :codigo_cnes_terceiro, :atende_ambulatorial_nao_sus,
         :atende_ambulatorial_sus, :atende_hospitalar_nao_sus, :atende_hospitalar_sus

  field :actions do |_object, options|
    options.dig(:permissions, :servico_unidade_saude) || {}
  end

  field :tipo_servico do |unit, options|
    ServicoSerializer.render_as_hash(unit.servico, options)
  end

  field :caracteristica do |unit, options|
    CaracteristicaServicoSerializer.render_as_hash(unit.caracteristica_servico, options)
  end

  association :classificacao, blueprint: ServicosClassificacaoSerializer
  association :endereco_complementar_unidade, blueprint: EnderecoComplementarUnidadeSerializer
end
