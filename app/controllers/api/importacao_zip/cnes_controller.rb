# frozen_string_literal: true

module Api
  module ImportacaoZip
    class CNESController < ApplicationController
      include ::Authorizable

      def create
        result = ::UnidadeSaude::ImportacaoZip::EnvioCNESService.call(create_params)

        case result
        in { success: data }
          render_204
        in { failure: error_message }
          render_422 error_message
        end
      end

      private

      def create_params
        params.require(:cnes_file).permit(:file)
      end
    end
  end
end
