# frozen_string_literal: true

module Agendas
  class ListarAuditsService
    def initialize(agenda_id, params = {})
      @agenda_id = agenda_id
      @page = params[:page] || 1
      @per_page = params[:per_page] || 10
      @order = params[:order] || 'created_at'
      @order_direction = params[:order_direction] || 'desc'
    end

    def call
      audits = fetch_all_related_audits
      success_response(audits)
    rescue ActiveRecord::RecordNotFound => e
      error_response(e.message)
    end

    private

    def fetch_all_related_audits
      agenda_audits = fetch_agenda_audits
      mapa_periodo_audits = fetch_mapa_periodo_audits
      mapa_dia_audits = fetch_mapa_dia_audits
      mapa_horario_audits = fetch_mapa_horario_audits

      all_audits = agenda_audits + mapa_periodo_audits + mapa_dia_audits + mapa_horario_audits

      Kaminari.paginate_array(all_audits).page(@page).per(@per_page)
    end

    def fetch_agenda_audits
      Agenda.find(@agenda_id)
        .audits
        .reorder("#{@order} #{@order_direction}")
    end

    def fetch_mapa_periodo_audits
      AgendaMapaPeriodo
        .joins('INNER JOIN agendas ON agendas.id = agendas_mapas_periodos.agenda_id')
        .where(agendas: { id: @agenda_id })
        .reorder("#{@order} #{@order_direction}")
        .flat_map(&:audits)
    end

    def fetch_mapa_dia_audits
      AgendaMapaDia
        .joins('INNER JOIN agendas_mapas_periodos ' \
               'ON agendas_mapas_periodos.id = agendas_mapas_dias.agenda_mapa_periodo_id')
        .where(agendas_mapas_periodos: { agenda_id: @agenda_id })
        .reorder("#{@order} #{@order_direction}")
        .flat_map(&:audits)
    end

    def fetch_mapa_horario_audits
      AgendaMapaHorario
        .joins('INNER JOIN agendas_mapas_dias ' \
               'ON agendas_mapas_dias.id = agendas_mapas_horarios.agenda_mapa_dia_id')
        .joins('INNER JOIN agendas_mapas_periodos ' \
               'ON agendas_mapas_periodos.id = agendas_mapas_dias.agenda_mapa_periodo_id')
        .joins('INNER JOIN agendas ON agendas.id = agendas_mapas_periodos.agenda_id')
        .where(agendas: { id: @agenda_id })
        .reorder("#{@order} #{@order_direction}")
        .flat_map(&:audits)
    end

    def success_response(audits)
      {
        success: true,
        data: audits,
        current_page: audits.current_page,
        total_pages: audits.total_pages,
        total_count: audits.total_count
      }
    end

    def error_response(error_message)
      { success: false, error: error_message }
    end
  end
end
