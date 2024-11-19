# frozen_string_literal: true

module Api
  module ServicosApoio
    class TiposController < ApplicationController
      def index
        case ::UnidadeSaude::ServicosApoio::BuscaTiposService.call(search_params)
        in success: tipos_servico_apoio
          render_200 serialize(tipos_servico_apoio, ::TipoServicoApoioSerializer)
        in failure: error
          render_422(error)
        end
      end

      def search_params
        params.permit(:nome)
      end
    end
  end
end
