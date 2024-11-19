# frozen_string_literal: true

module Api
  module UnidadeSaude
    class EquipesController < ApplicationController
      def index
        case ::UnidadeSaude::Equipes::BuscarService.call(index_params.to_h)
        in success: result
          render_200(
            serialize(result, ::BuscaEquipeSerializer),
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

      def show
        case ::UnidadeSaude::Equipes::DetalharService.call(show_params.to_h)
        in success: result
          render_200(
            serialize(result, ::BuscaEquipeSerializer)
          )
        in failure: error
          render_422 error
        end
      end

      def minimal
        case ::Equipes::ListEquipesService.call(minimal_params)
        in success: equipes
          render_200 serialize(equipes, ::EquipeMinimalSerializer)
        in failure: error
          render_422 error
        end
      end

      def micro_areas
        case ::Equipes::ListarMicroAreasPorEquipeService.call(params[:id], micro_area_params)
        in success: micro_areas
          render_200 serialize(micro_areas, ::MicroAreaSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def index_params
        params.require(:unidade_saude_id)
        params.permit(:unidade_saude_id, :term, :page, :per_page, :order, :order_direction)
      end

      def show_params
        params.require(:unidade_saude_id)
        params.require(:id)
        params.permit(:unidade_saude_id, :id)
      end

      def minimal_params
        params.permit(:term, :page, :per_page)
      end

      def micro_area_params
        params.permit(:id, :term)
      end
    end
  end
end
