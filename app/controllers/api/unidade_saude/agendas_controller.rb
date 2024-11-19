# frozen_string_literal: true

module Api
  module UnidadeSaude
    class AgendasController < ApplicationController
      def index
        agendas = ::Agendas::ListarService.call(index_params)

        case agendas
        in success: data
          render_200(
            serialize(data, ::AgendaSerializer, view: :normal),
            meta: pagination_meta(data)
          )
        in failure: error
          render_422 error
        end
      end

      # Faz push e verifi
      def show
        result = ::UnidadeSaude::Agendas::BuscarAgendaService.call(
          agenda_params[:id]
        )

        case result
        in success: agendas
          render_200 serialize(agendas, ::AgendaSerializer, view: :listagem_agenda)
        in failure: error_message
          render_422 error_message
        end
      end

      def create
        case ::Agendas::CreateAgendaService.call(create_params)
        in success: agenda
          render_201(
            AgendaSerializer.render_as_hash(agenda, view: :cadastro_agenda)
          )
        in failure: error
          if error[:status] == 400
            render_400 error[:error]
          else
            render_422 error[:error]
          end
        end
      end

      def update
        case ::Agendas::AtualizaAgendaService.call(id: params[:id], params: update_params)
        in success: agenda
          render_200(serialize(agenda, ::AgendaSerializer, view: :edicao_agenda))
        in failure: error
          render_422 error
        end
      end

      def conflitos
        case ::Agendas::BuscaConflitosService.call(conflitos_params)
        in success: agendas
          render_200 serialize(agendas, ListaAgendaSerializer)

        in failure: error
          if error[:status] == 400
            render_400 error[:error]
          else
            render_422 error[:error]
          end
        end
      end

      def tipos_bloqueios
        case ::Agendas::ListarTiposBloqueiosService.call(tipo_bloqueios_params)
        in success: tipo_bloqueios
          render_200 serialize(tipo_bloqueios, TipoBloqueioSerializer)
        in failure: error
          render_422 error
        end
      end

      def pendencias_bloqueios
        result = ::Agendas::ValidaExclusaoService.call(pendencias_bloqueios_params[:id])
        case result
        in success: pode_excluir
          render_200({ pode_excluir: })
        in failure: error
          if error[:status] == 400
            render_400 error[:error]
          else
            render_422 error[:error]
          end
        end
      end

      def mapas_periodos
        case ::Agendas::AgendaPeriodosService.call(params[:id], filter_params)
        in success: periodos
          render_200(
            serialize(periodos, AgendaPeriodoSerializer),
            meta: pagination_meta(periodos)
          )
        in failure: error
          render_422 error
        end
      end

      def mapa_periodo_show
        case ::Agendas::GetMapaPeriodoService.call(params[:mapa_periodo_id])
        in success: periodo
          render_200(
            serialize(periodo, AgendaPeriodoSerializer)
          )
        in failure: error
          render_422 error
        end
      end

      def mapa_periodo_create
        case ::Agendas::CreateMapaPeriodoService.call(params[:id], create_mapa_periodo_params)
        in success: periodo
          render_201(
            serialize(periodo, AgendaPeriodoSerializer)
          )
        in failure: error
          render_422 error
        end
      end

      def destroy
        case ::Agendas::DeletaAgendaService.call(agenda_params[:id])
        in success:
          render_204
        in failure: error
          render_400 error
        end
      end

      private

      def index_params
        params.permit(:page, :per_page, :order, :order_direction,
                      :data_inicial, :data_final, :unidade_saude_id,
                      :padrao_agenda_id, :profissional_id, :ocupacao_id,
                      :procedimento_id, :situacao, :local, :regulacao, :inativo)
      end

      def pagination_meta(data)
        {
          current_page: data.current_page,
          total_pages: data.total_pages.zero? ? 1 : data.total_pages,
          total_count: data.total_count
        }
      end

      def create_params
        params.require(:agenda).permit(
          :unidade_saude_ocupacao_id, :profissional_id, :procedimento_id, :possui_equipamento,
          :equipamento_utilizavel_id, :local, :regulacao,
          :sexo_id, :tipo_atendimento_agenda_id, :padrao_agenda_id, mapa_periodos: [
            :data_inicial, :data_final, :possui_horario_distribuido, :possui_tempo_atendimento_configurado,
            :inativo, :dias_agendamento, :data_liberacao_agendamento,
            { tempo_atendimento: %i[nova_consulta retorno reserva_tecnica regulacao regulacao_retorno],
              mapa_dias: [
                :dia_atendimento_id,
                { mapa_horarios: %i[
                  hora_inicio hora_fim retorno nova_consulta reserva_tecnica
                  regulacao regulacao_retorno hora_inicio_str hora_fim_str observacao grupo_atendimento_id
                ] }
              ] }
          ]
        )
      end

      def create_mapa_periodo_params
        params.require(:mapa_periodo).permit(
          :data_inicial, :data_final, :possui_horario_distribuido, :possui_tempo_atendimento_configurado,
          :inativo, :dias_agendamento, :data_liberacao_agendamento,
          { tempo_atendimento: %i[nova_consulta retorno reserva_tecnica regulacao regulacao_retorno],
            mapa_dias: [
              :dia_atendimento_id,
              { mapa_horarios: %i[
                hora_inicio hora_fim retorno nova_consulta reserva_tecnica
                regulacao regulacao_retorno hora_inicio_str hora_fim_str observacao grupo_atendimento_id
              ] }
            ] }
        )
      end

      def update_params
        params.permit(
          :profissional_id,
          :procedimento_id,
          :unidade_saude_ocupacao_id,
          :padrao_agenda_id,
          :equipamento_utilizavel_id,
          :grupo_atendimento_id,
          :possui_equipamento,
          :local,
          :regulacao,
          :inativo,
          agenda: %i[
            profissional_id
            procedimento_id
            unidade_saude_ocupacao_id
            padrao_agenda_id
            equipamento_utilizavel_id
            grupo_atendimento_id
            possui_equipamento
            local
            regulacao
          ]
        )
      end

      def conflitos_params
        params.permit(:profissional_id, :unidade_saude_id, :data_inicial, :data_final)
      end

      def tipo_bloqueios_params
        params.permit(:search_term)
      end

      def pendencias_bloqueios_params
        params.permit(:id)
      end

      def agenda_params
        params.permit(:id)
      end

      def filter_params
        params.permit(:id, :data_inicial, :data_final, :inativo, :order, :order_direction,
                      :page, :per_page, :order)
      end
    end
  end
end
