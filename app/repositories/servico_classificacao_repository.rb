# frozen_string_literal: true

class ServicoClassificacaoRepository < ApplicationRepository
  def self.find_by_codigo_servico(codigo_servico)
    ServicoClassificacao.where(codigo_servico:)
  end

  def self.all
    ServicoClassificacao.order(:classificacao)
  end
end
