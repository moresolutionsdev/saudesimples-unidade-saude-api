# frozen_string_literal: true

class ClassificacaoSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
