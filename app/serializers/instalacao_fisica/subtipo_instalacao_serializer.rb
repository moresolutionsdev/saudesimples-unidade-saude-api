# frozen_string_literal: true

class InstalacaoFisica
  class SubtipoInstalacaoSerializer < ApplicationSerializer
    identifier :id

    fields :id, :nome, :codigo
  end
end
