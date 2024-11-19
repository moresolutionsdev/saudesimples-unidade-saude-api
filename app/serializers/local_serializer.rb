# frozen_string_literal: true

class LocalSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :nome_contato
end
