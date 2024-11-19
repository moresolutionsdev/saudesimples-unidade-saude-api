# frozen_string_literal: true

class TipoBloqueioSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :fixo, :alias
end
