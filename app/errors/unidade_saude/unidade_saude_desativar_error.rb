# frozen_string_literal: true

class UnidadeSaude
  class UnidadeSaudeDesativarError < StandardError
    def initialize(message)
      super("Houve um erro ao tentar desativar a unidade de saúde: #{message}")
    end
  end
end
