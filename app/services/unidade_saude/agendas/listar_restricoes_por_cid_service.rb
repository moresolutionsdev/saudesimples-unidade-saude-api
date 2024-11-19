# frozen_string_literal: true

class UnidadeSaude
  module Agendas
    class ListarRestricoesPorCidService < ApplicationService
      def initialize(agenda_id, params = {})
        @agenda_id = agenda_id
        @page = params[:page] || 1
        @per_page = params[:per_page] || 10
        @order = params[:order] || 'created_at'
        @order_direction = params[:order_direction] || 'desc'
      end

      def call
        restricoes = fetch_restricoes
        success_response(restricoes)
      rescue ActiveRecord::RecordNotFound => e
        error_response(e.message)
      end

      def fetch_restricoes
        agenda = Agenda.find(@agenda_id)

        restricoes = ::AgendaRestricaoCid.where(
          agenda_id: agenda.id, deleted_at: nil
        ).reorder(
          "#{@order} #{@order_direction}"
        )

        Kaminari.paginate_array(restricoes).page(@page).per(@per_page)
      end

      def success_response(restricoes)
        {
          success: true,
          data: restricoes,
          current_page: restricoes.current_page,
          total_pages: restricoes.total_pages,
          total_count: restricoes.total_count
        }
      end

      def error_response(error_message)
        { success: false, error: error_message }
      end
    end
  end
end
