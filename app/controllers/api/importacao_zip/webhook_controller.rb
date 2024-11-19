# frozen_string_literal: true

module Api
  module ImportacaoZip
    class WebhookController < ActionController::API
      include ::Renderable

      def sync_unidades_saude
        result = ::UnidadeSaude::ImportacaoZip::SincronizarService.call

        case result
        in { success: data }
          render_204
        in { failure: error_message }
          render_422 error_message
        end
      end
    end
  end
end
