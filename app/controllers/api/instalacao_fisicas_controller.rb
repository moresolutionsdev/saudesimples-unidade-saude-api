# frozen_string_literal: true

module Api
  class InstalacaoFisicasController < ApplicationController
    def search
      case Instalacao::BuscarInstalacaoFisicaService.call(search_params)
      in success: instalacoes_fisicas
        render_200 serialize(instalacoes_fisicas, InstalacaoFisica::InstalacaoFisicaSerializer)
      in failure: _error
        render_200([])
      end
    end

    private

    def search_params
      params.permit(
        :id,
        :nome
      )
    end
  end
end
