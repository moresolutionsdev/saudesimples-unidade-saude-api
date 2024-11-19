# frozen_string_literal: true

class TipoEquipamentoSerializer < ApplicationSerializer
  identifier :id

  fields :codigo, :nome
end
