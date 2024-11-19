# frozen_string_literal: true

class AgendaBloqueioRepository < ApplicationRepository
  class << self
    delegate_missing_to AgendaBloqueio

    def search(params = {})
      bloqueios = base_query(params[:agenda_id])

      apply_ordering(params, bloqueios)
    end

    def find_bloqueio(agenda_id, bloqueio_id)
      AgendaBloqueio.find_by(id: bloqueio_id, agenda_id:)
    end

    def find_bloqueios_to_replicate(bloqueio)
      AgendaBloqueio.where(
        data_inicio: bloqueio.data_inicio,
        data_fim: bloqueio.data_fim,
        hora_inicio: bloqueio.hora_inicio,
        hora_fim: bloqueio.hora_fim
      ).where.not(agenda_id: bloqueio.agenda_id)
    end

    private

    def base_query(agenda_id)
      AgendaBloqueio.where(agenda_id:)
    end

    def apply_ordering(params, bloqueios)
      order_column = params[:order] || 'data_inicio'
      order_direction = params[:order_direction] || 'asc'

      bloqueios.order("#{order_column} #{order_direction}")
    end
  end
end
