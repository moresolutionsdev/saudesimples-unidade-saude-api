# frozen_string_literal: true

class AuthorizationService
  def initialize(user, unidade_saude)
    @user = user
    @unidade_saude = unidade_saude
    @ability = Ability.new(user, unidade_saude)
  end

  # rubocop:disable Metrics/AbcSize
  def permissions
    {
      edit: @ability.can?(:update, @unidade_saude),
      create: @ability.can?(:create, @unidade_saude),
      import: @ability.can?(:create, @unidade_saude),
      destroy: @ability.can?(:destroy, @unidade_saude),
      show: @ability.can?(:show, @unidade_saude),
      queue_panel: @ability.can?(:queue_panel, @unidade_saude),
      create_equipamento: @ability.can?(:manage, @unidade_saude),
      delete_equipamento: @ability.can?(:manage, @unidade_saude),
      create_servico_especializado: @ability.can?(:manage, @unidade_saude),
      servicos_apoio:,
      servico_unidade_saude:,
      servico_especializado:,
      instalacao_unidades:,
      vinculo_de_profissional:,
      termo_uso:,
      equipe:,
      agenda_bloqueios:
    }.with_indifferent_access
  end
  # rubocop:enable Metrics/AbcSize
  #

  private

  def servico_unidade_saude
    {
      delete: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def servicos_apoio
    {
      create: @ability.can?(:manage, @unidade_saude),
      delete: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def instalacao_unidades
    {
      create: @ability.can?(:manage, @unidade_saude),
      delete: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def servico_especializado
    {
      create: @ability.can?(:manage, @unidade_saude),
      delete: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def vinculo_de_profissional
    {
      create: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def termo_uso
    {
      download: true,
      show: true
    }.with_indifferent_access
  end

  def equipe
    {
      edit: @ability.can?(:manage, @unidade_saude),
      delete: @ability.can?(:manage, @unidade_saude),
      show: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end

  def agenda_bloqueios
    {
      delete: @ability.can?(:manage, @unidade_saude)
    }.with_indifferent_access
  end
end
