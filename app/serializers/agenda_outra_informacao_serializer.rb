# frozen_string_literal: true

class AgendaOutraInformacaoSerializer < ApplicationSerializer
  identifier :id

  field :agenda_id

  field :outra_informacao do |agenda_outra_informacao|
    outra_informacao = agenda_outra_informacao.outra_informacao

    {
      id: outra_informacao.id,
      nome: outra_informacao.nome,
      descricao: outra_informacao.descricao,
      padrao: outra_informacao.padrao
    }
  end
end
