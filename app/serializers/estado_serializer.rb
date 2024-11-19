# frozen_string_literal: true

class EstadoSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :uf, :pais_id, :codigo_dne
end
