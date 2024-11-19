# frozen_string_literal: true

class InstalacaoFisica
  class TipoInstalacaoFisicaSerializer < ApplicationSerializer
    identifier :id

    fields :id, :nome, :codigo
  end
end
