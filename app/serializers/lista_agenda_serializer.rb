# frozen_string_literal: true

class ListaAgendaSerializer < ApplicationSerializer
  field :agenda_id

  field :agendas_mapas_periodos do |agenda|
    agenda[:periodos_ids].zip(agenda[:periodos_data_inicial],
                              agenda[:periodos_data_final]).map do |id, data_inicial, data_final|
      {
        id:,
        data_inicial:,
        data_final:
      }
    end
  end
end
