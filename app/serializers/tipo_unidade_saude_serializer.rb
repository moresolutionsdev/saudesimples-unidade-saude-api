# frozen_string_literal: true

class TipoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
