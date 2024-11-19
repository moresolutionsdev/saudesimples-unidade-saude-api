# frozen_string_literal: true

module Api
  module Importacao
    class CNESController < ApplicationController
      include ::Authorizable

      def create
        result = ::UnidadeSaude::Importacao::CNESService.new(create_params).call

        case result
        in { success: data }
          render_200 result
        in { failure: error_message }
          render_422 error_message
        end
      end

      private

      def create_params
        params.require(:cnes)
      end
    end
  end
end
