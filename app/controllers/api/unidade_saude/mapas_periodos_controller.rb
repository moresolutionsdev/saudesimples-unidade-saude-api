# frozen_string_literal: true

module Api
  module UnidadeSaude
    class MapasPeriodosController < ApplicationController
      def update
        case ::UnidadeSaude::Agendas::UpdateMapaPeriodoService.call(params[:mapa_periodo_id], update_params.to_h)
        in success: mapa_periodo
          render_200 serialize(mapa_periodo, ::AgendaMapaPeriodoSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def update_params
        params.require(:mapa_periodo).permit(
          :data_inicial,
          :data_final,
          :possui_horario_distribuido,
          :possui_tempo_atendimento_configurado,
          :inativo,
          :dias_agendamento,
          :data_liberacao_agendamento,
          tempo_atendimento: %i[
            nova_consulta
            retorno
            reserva_tecnica
            regulacao
            regulacao_retorno
          ],
          mapa_dias: [
            :id,
            :_destroy,
            :dia_atendimento_id,
            { mapa_horarios: %i[
              id
              _destroy
              hora_inicio
              hora_fim
              retorno
              nova_consulta
              reserva_tecnica
              regulacao
              regulacao_retorno
              hora_inicio_str
              hora_fim_str
              observacao
              grupo_atendimento_id
            ] }
          ]
        )
      end
    end
  end
end
