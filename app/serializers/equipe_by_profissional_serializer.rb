# frozen_string_literal: true

class EquipeByProfissionalSerializer < ApplicationSerializer
  identifier :id

  field :nome do |equipe_profissional|
    equipe_profissional.equipe&.nome
  end

  field :codigo do |equipe_profissional|
    equipe_profissional.equipe&.codigo
  end

  fields :profissional_id, :equipe_id
end
