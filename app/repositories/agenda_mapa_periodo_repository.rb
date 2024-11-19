# frozen_string_literal: true

class AgendaMapaPeriodoRepository < ApplicationRepository
  class << self
    delegate_missing_to AgendaMapaPeriodo

    def buscar_conflitos(profissional_id:, unidade_saude_id:, data_inicial:, data_final:)
      # Busca os registros de AgendaMapaPeriodo relacionados ao profissional_id e unidade_saude_id
      Agenda
        .joins(:agenda_mapa_periodos, :unidade_saude_ocupacao)
        .where(
          'agendas.profissional_id = ? AND unidade_saude_id = ?',
          profissional_id,
          unidade_saude_id
        )
        .where(
          '(? BETWEEN agendas_mapas_periodos.data_inicial AND agendas_mapas_periodos.data_final)
          AND (? BETWEEN agendas_mapas_periodos.data_inicial AND agendas_mapas_periodos.data_final)',
          data_inicial,
          data_final
        )
        .select(
          'agendas.id as agenda_id',
          'ARRAY_AGG(agendas_mapas_periodos.id) as periodos_ids',
          'ARRAY_AGG(agendas_mapas_periodos.data_inicial) as periodos_data_inicial',
          'ARRAY_AGG(agendas_mapas_periodos.data_final) as periodos_data_final'
        )
        .group('agendas.id')
    end

    def create_with_associations(params)
      ActiveRecord::Base.transaction do
        agenda_mapa_periodo = create_agenda_mapa_periodo(params)

        create_agenda_mapa_periodo_tempo_atendimento(params, agenda_mapa_periodo)
        params[:mapa_dias].each do |dia|
          agenda_mapa_dia = create_agenda_mapa_dia(dia, agenda_mapa_periodo)
          dia[:mapa_horarios].each do |horario|
            create_agenda_mapa_horario(horario, agenda_mapa_dia)
          end
        end

        agenda_mapa_periodo
      end
    end

    def find_by_agenda_and_filters(agenda_id, filters = {})
      query = where(agenda_id:)

      query = apply_date_filters(query, filters)
      query = apply_inactive_filter(query, filters[:inativo])

      query.order(order_query(filters[:order], filters[:order_direction]))
      query.page(filters[:page]).per(filters[:per_page])
    end

    def create_agenda_mapa_periodo(params)
      create!(prepare_params_for_agenda_mapa_periodo_creation(params))
    end

    def create_agenda_mapa_dia(dia, agenda_map_periodo)
      AgendaMapaDia.create!(
        dia_atendimento_id: dia[:dia_atendimento_id],
        agenda_mapa_periodo_id: agenda_map_periodo.id
      )
    end

    def create_agenda_mapa_horario(horario, agenda_mapa_dia)
      AgendaMapaHorario.create!(
        agenda_mapa_dia_id: agenda_mapa_dia.id,
        hora_inicio: horario[:hora_inicio],
        hora_fim: horario[:hora_fim],
        retorno: horario[:retorno],
        nova_consulta: horario[:nova_consulta],
        reserva_tecnica: horario[:reserva_tecnica],
        regulacao: horario[:regulacao] || 0,
        regulacao_retorno: horario[:regulacao_retorno] || 0,
        hora_inicio_str: horario[:hora_inicio_str],
        hora_fim_str: horario[:hora_fim_str],
        observacao: horario[:observacao],
        grupo_atendimento_id: horario[:grupo_atendimento_id]
      )
    end

    def prepare_params_for_agenda_mapa_periodo_creation(periodo)
      {
        agenda_id: periodo[:agenda_id],
        data_inicial: periodo[:data_inicial],
        data_final: periodo[:data_final],
        possui_horario_distribuido: periodo[:possui_horario_distribuido] || false,
        possui_tempo_atendimento_configurado: periodo[:possui_tempo_atendimento_configurado] || false,
        inativo: periodo[:inativo] || false,
        dias_agendamento: periodo[:dias_agendamento],
        data_liberacao_agendamento: periodo[:data_liberacao_agendamento]
      }
    end

    def create_agenda_mapa_periodo_tempo_atendimento(periodo, agenda_mapa_periodo)
      agenda_mapa_periodo.agenda_mapa_periodo_tempo_atendimentos.create!(
        nova_consulta: periodo.dig(:tempo_atendimento, :nova_consulta) || 60,
        retorno: periodo.dig(:tempo_atendimento, :retorno) || 60,
        reserva_tecnica: periodo.dig(:tempo_atendimento, :reserva_tecnica) || 60,
        regulacao: periodo.dig(:tempo_atendimento, :regulacao) || 60,
        regulacao_retorno: periodo.dig(:tempo_atendimento, :regulacao_retorno) || 60
      )
    end

    def apply_date_filters(query, filters)
      query = query.where(data_inicial: filters[:data_inicial]..) if filters[:data_inicial].present?
      query = query.where(data_final: ..filters[:data_final]) if filters[:data_final].present?
      query
    end

    def apply_inactive_filter(query, inativo)
      inativo.nil? ? query : query.where(inativo:)
    end

    def order_query(order, order_direction)
      order_column = valid_order_column(order) ? order : 'data_inicial'
      direction = %w[ASC DESC].include?(order_direction) ? order_direction : 'ASC'
      "#{order_column} #{direction}"
    end

    def valid_order_column(order)
      %w[data_inicial data_final inativo].include?(order)
    end

    def update_with_associations(mapa_periodo_id, params)
      ActiveRecord::Base.transaction do
        # Encontra o mapa_periodo pelo ID
        mapa_periodo = AgendaMapaPeriodo.find(mapa_periodo_id)

        # Atualiza os atributos do mapa_periodo
        mapa_periodo.update!(
          data_inicial: params[:data_inicial],
          data_final: params[:data_final],
          possui_horario_distribuido: params[:possui_horario_distribuido],
          possui_tempo_atendimento_configurado: params[:possui_tempo_atendimento_configurado],
          inativo: params[:inativo],
          dias_agendamento: params[:dias_agendamento],
          data_liberacao_agendamento: params[:data_liberacao_agendamento]
        )

        # Atualiza ou cria registros de tempo_atendimento
        update_or_create_tempo_atendimentos(mapa_periodo, params[:tempo_atendimento])

        # Atualiza ou cria registros de mapa_dias e seus horários
        update_or_create_mapa_dias(mapa_periodo, params[:mapa_dias])

        mapa_periodo
      end
    end

    def update_or_create_tempo_atendimentos(mapa_periodo, tempo_atendimento_params)
      return unless tempo_atendimento_params

      # # Atualiza ou cria registros de agenda_mapa_periodo_tempo_atendimentos
      # mapa_periodo.agenda_mapa_periodo_tempo_atendimentos.destroy_all

      mapa_periodo.agenda_mapa_periodo_tempo_atendimentos.update!(
        nova_consulta: tempo_atendimento_params[:nova_consulta] || 60,
        retorno: tempo_atendimento_params[:retorno] || 60,
        reserva_tecnica: tempo_atendimento_params[:reserva_tecnica] || 60,
        regulacao: tempo_atendimento_params[:regulacao] || 60,
        regulacao_retorno: tempo_atendimento_params[:regulacao_retorno] || 60
      )
    end

    def update_or_create_mapa_dias(mapa_periodo, mapa_dias_params)
      return unless mapa_dias_params

      mapa_dias_params.each do |dia_params|
        if dia_params[:_destroy]
          # Remove o dia se _destroy estiver presente
          AgendaMapaDia.find(dia_params[:id]).destroy
        else
          # Encontra ou cria um mapa_dia
          mapa_dia = mapa_periodo.agenda_mapa_dias.find_or_initialize_by(id: dia_params[:id])

          # Atualiza o dia de atendimento
          mapa_dia.update!(
            dia_atendimento_id: dia_params[:dia_atendimento_id]
          )

          # Atualiza ou cria os horários associados ao dia
          update_or_create_mapa_horarios(mapa_dia, dia_params[:mapa_horarios])
        end
      end
    end

    def update_or_create_mapa_horarios(mapa_dia, mapa_horarios_params)
      return unless mapa_horarios_params

      mapa_horarios_params.each do |horario_params|
        if horario_params[:_destroy]
          destroy_horario(horario_params[:id]) if horario_params[:id]
        else
          create_or_update_horario(mapa_dia, horario_params)
        end
      end
    end

    def destroy_horario(horario_id)
      mapa_dia.agenda_mapa_horarios.find(horario_id).destroy
    end

    def create_or_update_horario(mapa_dia, horario_params)
      # Encontra ou inicializa o horário
      mapa_horario = mapa_dia.agenda_mapa_horarios.find_or_initialize_by(id: horario_params[:id])

      mapa_horario.assign_attributes(
        hora_inicio: horario_params[:hora_inicio],
        hora_fim: horario_params[:hora_fim],
        nova_consulta: horario_params[:nova_consulta],
        retorno: horario_params[:retorno],
        reserva_tecnica: horario_params[:reserva_tecnica],
        regulacao: horario_params[:regulacao],
        regulacao_retorno: horario_params[:regulacao_retorno],
        hora_inicio_str: horario_params[:hora_inicio_str],
        hora_fim_str: horario_params[:hora_fim_str],
        observacao: horario_params[:observacao],
        grupo_atendimento_id: horario_params[:grupo_atendimento_id]
      )

      mapa_horario.save!
    end
  end
end
