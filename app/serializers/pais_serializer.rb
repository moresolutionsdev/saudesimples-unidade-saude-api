# frozen_string_literal: true

class PaisSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo, :codigo_esus

  field :nome do |object|
    object.nome.capitalize
  end
end
