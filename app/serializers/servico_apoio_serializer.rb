# frozen_string_literal: true

class ServicoApoioSerializer < ApplicationSerializer
  identifier :id

  association :tipo_servico_apoio, blueprint: TipoServicoApoioSerializer
  association :caracteristica_servico, blueprint: CaracteristicaServicoSerializer

  field :actions do |_resource, options|
    {
      delete: options&.dig(:permissions, :servicos_apoio, :delete) || false
    }
  end
end
