# frozen_string_literal: true

module Api
  class TipoEquipesController < ApplicationController
    def index
      case TipoEquipes::ListTipoEquipesService.call(index_params)
      in success: tipo_equipes
        render_200(
          TipoEquipeSerializer.render_as_hash(tipo_equipes, view: :with_label),
          meta: {
            current_page: params[:page] || 1,
            total_pages: tipo_equipes.total_pages,
            total_count: tipo_equipes.total_count
          }
        )
      in failure: error
        render_422 error
      end
    end

    private

    def index_params
      params.permit(:sigla, :descricao, :page, :per_page)
    end
  end
end
