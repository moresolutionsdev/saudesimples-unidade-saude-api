# frozen_string_literal: true

module Api
  class MunicipiosController < ApplicationController
    def index
      case ::Endereco::Estados::BuscarMunicipiosPorEstadoService.call(index_params)
      in success: municipios
        render_200(
          serialize(municipios, MunicipioSerializer)
        )
      in failure: error
        render_500 error
      end
    end

    private

    def index_params
      params.permit(:page, :per_page, :estado_id)
    end
  end
end
