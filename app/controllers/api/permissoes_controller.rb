# frozen_string_literal: true

module Api
  class PermissoesController < ApplicationController
    # GET /api/unidade_saude/permissoes
    def index
      permissions = AuthorizationService.new(current_user, ::UnidadeSaude.new).permissions

      permissions[:user_id] = current_user.id

      render_200 serialize(permissions, ::PermissaoSerializer)
    end

    def search_params
      params.permit(:nome)
    end
  end
end
