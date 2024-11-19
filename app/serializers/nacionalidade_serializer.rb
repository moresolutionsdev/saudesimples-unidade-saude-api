# frozen_string_literal: true

class NacionalidadeSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :codigo
end
