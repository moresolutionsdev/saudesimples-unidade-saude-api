# frozen_string_literal: true

class DadosBuscaCepSerializer < ApplicationSerializer
  identifier :cep

  fields :logradouro, :bairro, :localidade, :uf, :ibge, :tipo
end
