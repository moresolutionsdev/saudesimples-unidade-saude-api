# frozen_string_literal: true

module Api
  class AgendasOutraInformacaoController < ApplicationController
    def index
      case ::Agendas::OutrasInformacoes::ListarService.call(index_params)
      in success: result
        render_200(
          serialize(result, AgendaOutraInformacaoSerializer),
          meta: {
            current_page: result.current_page,
            total_pages: result.total_pages,
            total_count: result.total_count
          }
        )
      in failure: error
        render_422 error
      end
    end

    private

    def index_params
      params.require(:agenda_id)
      params.permit(:agenda_id, :order, :order_direction, :page, :per_page)
    end
  end
end
