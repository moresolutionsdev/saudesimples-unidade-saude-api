# frozen_string_literal: true

module Api
  class NacionalidadesController < ApplicationController
    def index
      case ::Nacionalidades::ListarService.call
      in success: nacionalidades
        render_200 serialize(nacionalidades, NacionalidadeSerializer)
      in failure: error
        render_422 error
      end
    end
  end
end
