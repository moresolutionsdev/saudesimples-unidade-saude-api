# frozen_string_literal: true

module Api
  class UnidadeSaudeOcupacoesController < ApplicationController
    def index
      case ::UnidadeSaudeOcupacoes::ListarOcupacoesService.new(
        unidade_saude_id: params[:unidade_saude_id],
        params: index_params
      ).call
      in success: ocupacoes
        render_200(
          serialize(ocupacoes, UnidadeSaudeOcupacaoSerializer, view: :listagem_agenda)
        )
      in failure: error_message
        render_422 error_message
      end
    end

    private

    def index_params
      params.permit(:profissional_id, :term)
    end
  end
end
