# frozen_string_literal: true

class UnidadeSaude
  class UnidadeSaudeAtualizarError < StandardError
    def initialize(message)
      super("Falha ao atualizar a unidade de saúde: #{message}")
    end
  end
end
