# frozen_string_literal: true

class ProfissionalSerializer < ApplicationSerializer
  identifier :id

  fields :id, :nome, :matricula, :cpf_numero, :codigo_cns

  view :listagem_agenda do
    fields :codigo, :nome

    exclude :matricula
    exclude :cpf_numero
    exclude :codigo_cns
  end
end
