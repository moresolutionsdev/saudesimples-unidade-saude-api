# frozen_string_literal: true

module Api
  module UnidadeSaude
    module Agendas
      class BloqueiosController < ApplicationController
        def create
          case ::Agendas::BloquearAgendaService.call(agenda_id: params[:agenda_id], params: create_params)
          in success: result
            render_204
          in failure: error
            render_400 error
          end
        end

        private

        def create_params
          params.permit(:data_inicio, :data_fim, :hora_inicio, :hora_fim, :tipo_bloqueio_id, :motivo,
                        :escolher_horario_bloqueio, :replicar_bloqueio)
        end
      end
    end
  end
end
