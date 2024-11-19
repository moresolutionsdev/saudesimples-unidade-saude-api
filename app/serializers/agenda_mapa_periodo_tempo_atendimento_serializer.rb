# frozen_string_literal: true

class AgendaMapaPeriodoTempoAtendimentoSerializer < ApplicationSerializer
  identifier :id

  fields :nova_consulta, :retorno, :reserva_tecnica, :regulacao, :regulacao_retorno
end
