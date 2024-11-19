# frozen_string_literal: true

class SubtipoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
