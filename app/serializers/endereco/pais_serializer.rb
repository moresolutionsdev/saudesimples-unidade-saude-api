# frozen_string_literal: true

module Endereco
  class PaisSerializer < ApplicationSerializer
    identifier :id

    fields :nome, :codigo, :codigo_esus
  end
end
