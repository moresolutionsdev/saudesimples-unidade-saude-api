# frozen_string_literal: true

class PermissaoSerializer < ApplicationSerializer
  identifier :user_id

  fields :show, :edit, :destroy, :create, :import, :create_equipamento, :create_servico_especializado
end
