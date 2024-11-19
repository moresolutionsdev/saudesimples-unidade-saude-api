# frozen_string_literal: true

class TipoDeServicoSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome
end
