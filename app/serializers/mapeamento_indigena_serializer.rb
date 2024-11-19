# frozen_string_literal: true

class MapeamentoIndigenaSerializer < ApplicationSerializer
  identifier :id

  fields :codigo_dsei,
         :dsei,
         :polo_base,
         :aldeia
end
