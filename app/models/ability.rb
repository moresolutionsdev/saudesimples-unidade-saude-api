# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/AbcSize
  def initialize(user, unidade_saude)
    return false if user.nil? || unidade_saude.nil? # rubocop:disable Lint/ReturnInVoidContext

    can_manage_unidade_saude(user, unidade_saude)
    can_painel_de_senha(user, unidade_saude)

    if user.tem_perfil?(%i[administrador_unidade diretor_unidade])
      if can_manage_unidade_saude(user, unidade_saude)
        can %i[read update], UnidadeSaude, id: unidade_saude.try(:id)
        cannot :ativar, UnidadeSaude, id: unidade_saude.try(:id)
        can :ativar, UnidadeSaude, inativa: true, id: unidade_saude.try(:id)
        cannot :update, UnidadeSaude, inativa: true, id: unidade_saude.try(:id)
        can :show, UnidadeSaude, inativa: false, id: unidade_saude.try(:id)
        can_destroy_unidade(unidade_saude)
      end
    elsif user.tem_perfil?(:secretaria_saude)
      if can_manage_unidade_saude(user, unidade_saude)
        cannot :ativar, UnidadeSaude
        can :ativar, UnidadeSaude, inativa: true
        cannot [:update], UnidadeSaude, inativa: true
        cannot :show, UnidadeSaude, inativa: false
        can_destroy_unidade(unidade_saude)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def can_manage_unidade_saude(user, _unidade_saude)
    can :manage, UnidadeSaude if user.tem_perfil?(%i[administrador_sistema diretor_unidade])
  end

  def can_painel_de_senha(user, unidade)
    cannot :queue_panel, UnidadeSaude
    can :queue_panel, UnidadeSaude if user.tem_perfil?(%i[administrador_sistema
                                                          administrador_unidade]) && unidade.painel_senha.present?
  end

  def can_destroy_unidade(_unidade_saude)
    can :destroy, UnidadeSaude, inativa: false
    cannot :destroy, UnidadeSaude, inativa: true
  end
end
