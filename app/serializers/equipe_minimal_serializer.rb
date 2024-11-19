# frozen_string_literal: true

class EquipeMinimalSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome
end
