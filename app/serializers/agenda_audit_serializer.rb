# frozen_string_literal: true

class AgendaAuditSerializer < ApplicationSerializer
  identifier :id

  field :auditable_id
  field :auditable_type
  field :associated_id
  field :associated_type
  field :action
  field :audited_changes
  field :version
  field :comment
  field :remote_address
  field :created_at

  association :user, blueprint: UsuarioSerializer

  field :user_type
  field :username
end
