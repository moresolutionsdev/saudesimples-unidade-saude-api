# frozen_string_literal: true

module Api
  class PaisesController < ApplicationController
    def index
      case ::Endereco::Paises::ListarService.call(index_params)
      in success: paises
        render_200(
          serialize(paises, PaisSerializer),
          meta: {
            current_page: (params[:page] || 1).to_i,
            total_pages: paises.total_pages,
            total_count: paises.total_count
          }
        )
      in failure: error
        render_500 error
      end
    end

    private

    def index_params
      params.permit(:page, :per_page, :search_term)
    end
  end
end
