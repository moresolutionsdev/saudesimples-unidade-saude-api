# frozen_string_literal: true

class AgendaBloqueioSerializer < ApplicationSerializer
  identifier :id

  fields :data_inicio, :data_fim, :hora_inicio, :hora_fim, :motivo, :automatico

  association :tipo_bloqueio, blueprint: TipoBloqueioSerializer

  field :actions do |unit, options|
    user = options[:current_user]
    authorization_service = AuthorizationService.new(user, unit.agenda.unidade_saude)
    authorization_service.permissions[:agenda_bloqueios] || false
  end
end
