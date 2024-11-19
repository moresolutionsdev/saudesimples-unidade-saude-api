# frozen_string_literal: true

class AuditoriaSerializer < ApplicationSerializer
  identifier :id

  fields :action, :auditable_type, :auditable_id, :user_id, :created_at
end
