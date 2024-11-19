# frozen_string_literal: true

class AgendamentoRepository < ApplicationRepository
  class << self
    delegate_missing_to Agendamento

    def agendamento_ids(id)
      Agendamento.where(agenda_id: id).pluck(:id)
    end
  end
end
