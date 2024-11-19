# frozen_string_literal: true

class AreaSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo, :municipio_id, :segmento_id
end
