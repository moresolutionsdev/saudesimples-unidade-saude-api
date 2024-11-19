# frozen_string_literal: true

module Api
  module ServicosApoio
    class CaracteristicasServicosController < ApplicationController
      def index
        case CaracteristicaServico::BuscarCaracteristicasServicosService.call
        in success: caracteristicas_servicos
          render_200 serialize(caracteristicas_servicos, ::CaracteristicaServicoSerializer)
        in failure: error
          render_422 error
        end
      end
    end
  end
end
