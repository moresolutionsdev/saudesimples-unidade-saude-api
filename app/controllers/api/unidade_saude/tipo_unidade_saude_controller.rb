# frozen_string_literal: true

module Api
  module UnidadeSaude
    class TipoUnidadeSaudeController < ApplicationController
      def index
        case ::UnidadeSaude::BuscaClassificacaoUnidadeSaudeService.call
        in success: result
          render_200(result)
        in failure: error
          render_422 error
        end
      end

      def search_params
        params.permit(:nome)
      end
    end
  end
end
