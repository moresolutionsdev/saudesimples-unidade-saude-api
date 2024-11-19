# frozen_string_literal: true

module Api
  module UnidadeSaude
    module Agendas
      class RestricoesCidsController < ApplicationController
        def index
          result = ::UnidadeSaude::Agendas::ListarRestricoesPorCidService.call(
            agenda_params[:id],
            agenda_params
          )

          if result[:success]
            render_200(
              serialize(result[:data], ::AgendaRestricaoCidSerializer, view: :list),
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

        def agenda_params
          params.permit(:id, :per_page, :order, :order_direction)
        end
      end
    end
  end
end
