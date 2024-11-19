# frozen_string_literal: true

class ClassificacaoUnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome
end
