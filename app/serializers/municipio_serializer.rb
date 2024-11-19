# frozen_string_literal: true

class MunicipioSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :ibge

  field :nome do |municipio, _|
    municipio.nome.split.map(&:capitalize).join(' ')
  end

  view :normal do
    fields :nome, :ibge
  end
end
