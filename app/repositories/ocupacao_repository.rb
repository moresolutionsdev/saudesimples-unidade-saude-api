# frozen_string_literal: true

class OcupacaoRepository < ApplicationRepository
  def self.search_by_codigo(codigo)
    Ocupacao.where(codigo:)
  end

  def self.upsert_ocupacao(codigo, nome)
    ocupacao = ::Ocupacao.find_or_initialize_by(codigo:)
    ocupacao.update(nome:)

    raise ActiveRecord::RecordInvalid, ocupacao unless ocupacao.valid?

    ocupacao
  end
end
