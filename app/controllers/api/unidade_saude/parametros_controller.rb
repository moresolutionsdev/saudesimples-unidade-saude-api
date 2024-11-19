# frozen_string_literal: true

module Api
  module UnidadeSaude
    class ParametrosController < ApplicationController
      def index
        case ::UnidadeSaude::BuscarParametrosService.call(parametros_params.to_h)
        in success: parametros
          render_200 serialize(parametros, ::ParametroSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def parametros_params
        params.permit(:unidade_saude_id)
      end
    end
  end
end
