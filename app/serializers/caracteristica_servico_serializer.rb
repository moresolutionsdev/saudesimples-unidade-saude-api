# frozen_string_literal: true

class CaracteristicaServicoSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
