# frozen_string_literal: true

module Api
  class AreasController < ApplicationController
    def index
      result = ::Areas::ListarAreaService.new(index_params.to_h).call

      case result
      in success: data
        render_200(
          serialize(data, AreaSerializer),
          meta: pagination_meta(data)
        )
      in failure: error
        render_422 error
      end
    end

    private

    def index_params
      params.permit(:nome, :codigo, :municipio_id, :segmento_id, :page, :per_page, :order, :order_direction)
    end

    def pagination_meta(data)
      {
        current_page: data.current_page,
        total_pages: data.total_pages,
        total_count: data.total_count
      }
    end
  end
end
