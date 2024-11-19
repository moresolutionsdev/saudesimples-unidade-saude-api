# frozen_string_literal: true

class EnderecoComplementarUnidadeSerializer < ApplicationSerializer
  identifier :id

  fields :id, :codigo, :logradouro, :logradouro_numero, :complemento, :bairro, :telefone,
         :email

  association :municipio, blueprint: MunicipioSerializer
  association :estado, blueprint: EstadoSerializer
end
