# frozen_string_literal: true

class AgendaRestricaoCidSerializer < ApplicationSerializer
  identifier :id

  view :list do
    field :cid do |object|
      {
        id: object.id,
        co_cid: object.codigo_cid,
        no_cid: Cid.find_by!(codigo: object.codigo_cid).nome
      }
    end
  end
end
