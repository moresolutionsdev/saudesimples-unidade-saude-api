# frozen_string_literal: true

class ServicoSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
