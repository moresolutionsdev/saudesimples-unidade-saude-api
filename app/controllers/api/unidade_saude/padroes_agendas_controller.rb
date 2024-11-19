# frozen_string_literal: true

module Api
  module UnidadeSaude
    class PadroesAgendasController < ApplicationController
      def index
        case PadroesAgendas::ListagemService.call
        in success: result
          render_200(
            serialize(result, PadraoAgendaSerializer)
          )
        in failure: error
          render_422 error
        end
      end
    end
  end
end
