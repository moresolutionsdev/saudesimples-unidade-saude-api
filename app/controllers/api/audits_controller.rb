# frozen_string_literal: true

module Api
  class AuditsController < ApplicationController
    def index
      case ::Audits::BuscarAuditsService.call(index_params)
      in success: audits
        render_200(
          serialize(audits, ::AuditsSerializer),
          meta: {
            current_page: params[:page] || 1,
            total_pages: audits.total_pages,
            total_count: audits.total_count
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
        :date_start,
        :date_end,
        :term,
        :auditable
      )
    end
  end
end
