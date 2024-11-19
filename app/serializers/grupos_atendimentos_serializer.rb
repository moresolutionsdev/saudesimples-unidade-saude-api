# frozen_string_literal: true

class GruposAtendimentosSerializer < ApplicationSerializer
  identifier :id

  fields :quantidade_maxima

  field :unidade_saude do |object|
    {
      id: object.unidade_saude.id,
      nome: object.unidade_saude.nome
    }
  end

  field :profissional do |object|
    {
      id: object.profissional.id,
      nome: object.profissional.nome
    }
  end
end
