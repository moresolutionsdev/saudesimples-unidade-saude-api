# frozen_string_literal: true

module Api
  class ProfissionaisController < ApplicationController
    def index
      case ::Profissional::BuscarProfissionaisService.call(index_params)
      in success: profissionais
        render_200(
          serialize(profissionais, ::ProfissionalSerializer),
          meta: {
            current_page: params[:page] || 1,
            total_pages: profissionais.total_pages,
            total_count: profissionais.total_count
          }
        )
      in failure: error
        render_422 error
      end
    end

    private

    def index_params
      params.permit(
        :page,
        :per_page,
        :order,
        :order_direction,
        :nome
      )
    end
  end
end
