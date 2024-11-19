# frozen_string_literal: true

class OcupacaoSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome, :saude
end
