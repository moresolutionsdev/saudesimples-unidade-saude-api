# frozen_string_literal: true

module Api
  class UnidadeSaudeMinimalController < ApplicationController
    #
    # GET /unidade_saude/listagem_reduzida
    def listagem_reduzida
      case ::UnidadeSaude::ListaUnidadesSaudeService.new(index_params).call
      in success: unidades_saude
        render_200(
          serialize(unidades_saude, UnidadeSaudeListaReduzidaSerializer)
        )
      in failure: error_message
        render_422 error_message
      end
    end

    private

    def index_params
      params.permit(:situacao, :status, :term, :cnes, :page, :per_page, :order, :order_direction, :exportacao_esus)
    end
  end
end
