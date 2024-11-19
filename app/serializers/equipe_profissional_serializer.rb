# frozen_string_literal: true

class EquipeProfissionalSerializer < ApplicationSerializer
  identifier :id

  field :codigo_micro_area

  field :entrada
  field :data_saida

  association :profissional, blueprint: ProfissionalSerializer do |equipe_profissional|
    {
      id: equipe_profissional.profissional.id,
      nome: equipe_profissional.profissional.nome
    }
  end

  association :ocupacao, blueprint: OcupacaoSerializer do |equipe_profissional|
    {
      id: equipe_profissional.ocupacao.id,
      nome: equipe_profissional.ocupacao.nome
    }
  end

  field :actions do |_equipe_profissional|
    {
      show: true,
      delete: true
    }
  end
end
