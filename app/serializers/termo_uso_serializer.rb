# frozen_string_literal: true

class TermoUsoSerializer < ApplicationSerializer
  identifier :id

  view :default do
    fields :titulo, :texto, :versao, :documento_tipo, :updated_at

    field :created_at do |object|
      object.created_at.strftime('%Y-%m-%d')
    end

    field :documento_arquivo_url do |object|
      object.documento_arquivo_url if object.documento_arquivo.attached?
    end

    field :usuario do |object|
      {
        id: object.usuario.id,
        email: object.usuario.email
      }
    end
  end

  view :with_actions do
    include_view :default

    field :actions do |_object, _options|
      {
        download: true,
        show: true
      }
    end
  end
end
