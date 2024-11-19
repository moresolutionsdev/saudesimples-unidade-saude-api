# frozen_string_literal: true

module Api
  module UnidadeSaude
    class ProfissionalController < ApplicationController
      # GET /api/unidade_saude/:id/profissional
      def create
        result = ::UnidadeSaude::Profissional::VinculaProfissionalUnidadeSaudeService.call(
          profissional_params.merge(current_user:, unidade_saude_id: params.require(:unidade_saude_id))
        )

        case result
        in success: profissionais
          render_200 serialize(profissionais, ::ProfissionalUnidadeSaudeSerializer)
        in failure: error_message
          render_422 error_message
        end
      end

      private

      def profissional_params
        params.permit(:profissional_id, :ocupacao_id)
      end
    end
  end
end
