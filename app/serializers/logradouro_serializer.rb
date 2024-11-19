# frozen_string_literal: true

class LogradouroSerializer < ApplicationSerializer
  identifier :id

  fields :nome, :bairro, :cep, :tipo_logradouro_id
end
