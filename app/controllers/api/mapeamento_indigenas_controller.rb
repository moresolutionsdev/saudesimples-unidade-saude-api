# frozen_string_literal: true

module Api
  class MapeamentoIndigenasController < ApplicationController
    def index
      case MapeamentoIndigenas::ListMapeamentoIndigenasService.call(index_params)
      in success: mapeamento_indigenas
        render_200(
          serialize(mapeamento_indigenas, ::MapeamentoIndigenaSerializer),
          meta: {
            current_page: params[:page] || 1,
            total_pages: mapeamento_indigenas.total_pages,
            total_count: mapeamento_indigenas.total_count
          }
        )
      in failure: error
        render_422 error
      end
    end

    private

    def index_params
      params.permit(:search_term, :page, :per_page)
    end
  end
end
