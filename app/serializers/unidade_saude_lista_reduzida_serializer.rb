# frozen_string_literal: true

class UnidadeSaudeListaReduzidaSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo_cnes, :exportacao_esus
end
