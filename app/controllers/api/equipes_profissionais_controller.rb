# frozen_string_literal: true

module Api
  class EquipesProfissionaisController < ApplicationController
    def index
      case ::Equipes::Profissionais::ListarService.call(index_params)
      in success: result
        render_200(
          serialize(result, EquipeProfissionalSerializer),
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
      params.require(:equipe_id)
      params.permit(:equipe_id, :term, :order, :order_direction).merge(pagination_params)
    end
  end
end
