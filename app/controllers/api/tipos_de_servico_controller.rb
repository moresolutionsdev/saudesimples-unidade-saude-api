# frozen_string_literal: true

module Api
  class TiposDeServicoController < ApplicationController
    def index
      case ::UnidadeSaude::BuscarServicosService.call
      in success: servicos
        render_200 serialize(servicos, TipoDeServicoSerializer)
      in failure: _error
        render_200 []
      end
    end
  end
end
