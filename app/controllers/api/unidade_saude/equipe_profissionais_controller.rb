# frozen_string_literal: true

module Api
  module UnidadeSaude
    class EquipeProfissionaisController < ApplicationController
      def index
        case ::UnidadeSaude::EquipeProfissionais::ListarService.call(index_params.to_h)
        in success: result
          render_200(
            serialize(result, EquipeProfissionalSerializer),
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

      def by_profissional
        case ::UnidadeSaude::EquipeProfissionais::ListarService.call(by_profissional_params.to_h, use_paginate: false)
        in success: result
          render_200(
            serialize(result, EquipeByProfissionalSerializer)
          )
        in failure: error
          render_422 error
        end
      end

      private

      def by_profissional_params
        params.permit(:profissional_id)
      end

      def index_params
        params.require(:unidade_saude_id)
        params.require(:equipe_id)
        params.permit(:unidade_saude_id, :equipe_id, :term, :page, :per_page, :order, :order_direction)
      end
    end
  end
end
