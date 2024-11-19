# frozen_string_literal: true

class TipoEquipeSerializer < ApplicationSerializer
  fields :id, :codigo, :sigla, :descricao

  view :with_label do
    field :label do |tipo_equipe|
      "#{tipo_equipe.codigo} - #{tipo_equipe.sigla} - #{tipo_equipe.descricao}"
    end
  end
end
