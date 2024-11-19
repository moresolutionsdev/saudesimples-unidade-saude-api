# frozen_string_literal: true

class UnidadeSaude
  class UnidadeSaudeCriacaoError < StandardError
    def initialize(message)
      super("Falha ao criar a unidade de saúde: #{message}")
    end
  end
end
