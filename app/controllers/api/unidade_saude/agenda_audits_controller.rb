# frozen_string_literal: true

module Api
  module UnidadeSaude
    class AgendaAuditsController < ApplicationController
      def index
        result = ::Agendas::ListarAuditsService.new(params[:agenda_id], index_params).call

        if result[:success]
          render_200(
            serialize(result[:data], AgendaAuditSerializer),
            meta: {
              current_page: result[:current_page],
              total_pages: result[:total_pages],
              total_count: result[:total_count]
            }
          )
        else
          render_422(result[:error])
        end
      end

      private

      def index_params
        params.permit(:page, :per_page, :order, :order_direction)
      end
    end
  end
end
