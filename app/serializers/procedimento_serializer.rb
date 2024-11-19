# frozen_string_literal: true

class ProcedimentoSerializer < ApplicationSerializer
  identifier :id

  fields :nome

  view :listagem_agenda do
    identifier :id

    fields :codigo, :nome
  end
end
