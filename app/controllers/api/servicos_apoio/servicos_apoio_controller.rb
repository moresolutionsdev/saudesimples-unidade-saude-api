# frozen_string_literal: true

module Api
  module ServicosApoio
    class ServicosApoioController < ApplicationController
      before_action :authorize_action!, only: %i[create destroy]

      def index
        case ::ServicoApoio::BuscarServicosApoioService.call(index_params)
        in success: servicos_apoio
          render_200(
            serialize(servicos_apoio, ::ServicoApoioSerializer),
            meta: {
              current_page: params[:page] || 1,
              total_pages: servicos_apoio.total_pages,
              total_count: servicos_apoio.total_count
            }
          )
        in failure: error
          render_422 error
        end
      end

      def create
        case ::ServicoApoio::CriarServicosApoioService.call(create_params)
        in success: servico_apoio
          render_201 serialize(servico_apoio, ::ServicoApoioSerializer)
        in failure: error
          render_400 error
        end
      end

      def destroy
        case ::ServicoApoio::DeletarServicosApoioService.call(params[:id])
        in success: _
          render_204
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
          :order_direction
        ).merge(
          unidade_saude_id: unidade_saude.id
        )
      end

      def create_params
        params.permit(
          :tipo_servico_apoio_id,
          :caracteristica_servico_id
        ).merge(
          unidade_saude_id: unidade_saude.id
        )
      end
    end
  end
end
