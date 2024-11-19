# frozen_string_literal: true

class ClassificacaoUnidadeSaudeRepository < ApplicationRepository
  def self.all
    ClassificacaoCNES.order(:nome)
  end

  def self.search_by_codigo(codigo)
    ClassificacaoCNES.where(codigo:)
  end

  def self.create(params)
    nova_classificacao_cnes = ClassificacaoCNES.new(params)

    unless nova_classificacao_cnes.valid?
      raise ::ClassificacaoCNESCriacaoError.new(nova_classificacao_cnes.errors.full_messages).message
    end

    nova_classificacao_cnes.save!

    nova_classificacao_cnes
  rescue StandardError => e
    raise ::ClassificacaoCNESCriacaoError, e.message
  end
end
