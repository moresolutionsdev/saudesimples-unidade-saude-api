# frozen_string_literal: true

class ClassificacaoCNESCriacaoError < StandardError
  def initialize(message)
    super("Falha ao criar a classificação CNES: #{message}")
  end
end
