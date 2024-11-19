# frozen_string_literal: true

module Api
  module UnidadeSaude
    class GruposAtendimentosController < ApplicationController
      def index
        case ::UnidadeSaude::GrupoAtendimentoService.call(filter_params)
        in success: result
          render_200 serialize(result, GruposAtendimentosSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def filter_params
        params.permit(:profissional_id, :search_term, :unidade_saude_id)
      end
    end
  end
end
