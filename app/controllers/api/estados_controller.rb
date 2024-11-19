# frozen_string_literal: true

module Api
  class EstadosController < ApplicationController
    def index
      case ::Endereco::ListarEstadosService.call
      in success: estados
        render_200(
          serialize(estados, EstadoSerializer)
        )
      in failure: error
        render_500 error
      end
    end
  end
end
