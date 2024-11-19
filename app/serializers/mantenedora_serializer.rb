# frozen_string_literal: true

class MantenedoraSerializer < ApplicationSerializer
  identifier :id

  fields :cnpj_numero, :nome, :logradouro, :numero,
         :complemento, :bairro, :cep, :telefone, :estado_id, :tipo_logradouro_id, :codigo_regiao_saude

  view :normal do
    fields :cnpj_numero, :nome, :logradouro, :numero,
           :complemento, :bairro, :cep, :telefone, :estado_id, :tipo_logradouro_id, :codigo_regiao_saude

    association :municipio, blueprint: MunicipioSerializer, view: :normal
  end
end
