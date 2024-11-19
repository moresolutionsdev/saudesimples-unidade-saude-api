# frozen_string_literal: true

module Equipes
  class ExcluirService < ApplicationService
    def initialize(params)
      @equipe_id = params[:equipe_id]
      @user = params[:user]
    end

    def call
      return Failure.new('Usuário não tem permissão para excluir equipe') unless can_destroy?

      EquipeRepository.destroy(@equipe_id)

      Success.new(:ok)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end

    private

    def can_destroy?
      @user.tem_perfil?(%i[administrador_om30 administrador_sistema administrador_unidade])
    end
  end
end
