# frozen_string_literal: true

module Api
  class OcupacoesController < ApplicationController
    def index
      case ::Ocupacao::BuscarOcupacoesService.call(index_params)
      in success: ocupacoes
        render_200(
          serialize(ocupacoes, ::OcupacaoSerializer),
          meta: {
            current_page: params[:page] || 1,
            total_pages: ocupacoes.total_pages,
            total_count: ocupacoes.total_count
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
        :nome,
        :codigo,
        :saude,
        :search_term
      )
    end
  end
end
