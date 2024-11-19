# frozen_string_literal: true

module Api
  class AgendasBloqueiosController < ApplicationController
    def index
      case ::Agendas::Bloqueios::ListarService.call(index_params)
      in success: result
        render_200(
          serialize(result, AgendaBloqueioSerializer),
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

    def destroy
      result = ::Agendas::Bloqueios::RemoverService.call(destroy_params)

      case result
      in success:
        head :no_content
      in failure: error
        render_422(error)
      end
    end

    def destroy_params
      params.permit(:agenda_id, :id, :replicar)
    end

    private

    def index_params
      params.require(:agenda_id)
      params.permit(:agenda_id, :order, :order_direction, :page, :per_page)
    end
  end
end
