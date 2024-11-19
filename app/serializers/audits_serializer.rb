# frozen_string_literal: true

class AuditsSerializer < ApplicationSerializer
  identifier :id

  association :user, blueprint: UsuarioSerializer

  fields :auditable_id, :auditable_type, :associated_id, :associated_type, :user_id, :user_type,
         :action, :audited_changes, :version, :comment, :remote_address, :request_uuid,
         :created_at

  field :username do |audit|
    audit.user&.profissional&.nome
  end
end
