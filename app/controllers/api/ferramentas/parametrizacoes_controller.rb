# frozen_string_literal: true

module Api
  module Ferramentas
    class ParametrizacoesController < ApplicationController
      def index
        case ::Ferramentas::Parametrizacao::ListarService.call
        in success: parametrizacao
          render_200 serialize(parametrizacao, ParametrizacaoSerializer)
        in failure: error
          render_422 error
        end
      end

      def update
        case ::Ferramentas::Parametrizacao::UpdateService.call(update_params)
        in success: parametrizacao
          render_200 serialize(parametrizacao, ParametrizacaoSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def update_params
        params.permit(:logo_municipio).merge(id: params[:id])
      end
    end
  end
end
