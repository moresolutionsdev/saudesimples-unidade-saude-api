# frozen_string_literal: true

class TipoServicoApoioSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome
end
