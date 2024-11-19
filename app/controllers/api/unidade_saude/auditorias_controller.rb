# frozen_string_literal: true

module Api
  module UnidadeSaude
    class AuditoriasController < ApplicationController
      def index
        case ::UnidadeSaude::AuditoriaService.call(params[:id].to_i, auditoria_params.to_h)
        in success: result
          render_200(
            serialize(result, AuditsSerializer, {}),
            meta: {
              current_page: params[:page] || 1,
              total_pages: result.total_pages,
              total_count: result.total_count
            }
          )
        in failure: error
          render_422 error
        end
      end

      private

      def auditoria_params
        params.permit(:id, :page, :per_page, :order, :order_direction, :date_start, :date_end, :term)
      end
    end
  end
end
