# frozen_string_literal: true

class AgendaOutraInformacaoRepository < ApplicationRepository
  class << self
    delegate_missing_to AgendaOutraInformacao

    def search(params = {})
      agenda_outras_informacoes = base_query(params[:agenda_id])

      apply_ordering(params, agenda_outras_informacoes)
    end

    private

    def base_query(agenda_id)
      AgendaOutraInformacao.includes(:outra_informacao).where(agenda_id:)
    end

    def apply_ordering(params, agenda_outras_informacoes)
      order_column = params[:order] || 'id'
      order_direction = params[:order_direction] || 'asc'

      agenda_outras_informacoes.order("#{order_column} #{order_direction}")
    end
  end
end
