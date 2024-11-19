# frozen_string_literal: true

module Authorizable
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError; end

  included do |base|
    base.rescue_from AuthorizationError, with: -> { render_403 }
  end

  def unidade_saude
    @unidade_saude ||= UnidadeSaude.find(params[:unidade_saude_id])
  end

  def permissions
    @permissions ||= AuthorizationService.new(current_user, unidade_saude).permissions
  end

  # rubocop:disable  Metrics/CyclomaticComplexity
  def authorize_action!(resource = controller_name.to_sym, action = action_name.to_sym)
    actions = case action
              when :index, :show then [:show]
              when :create, :new then [:create]
              when :edit, :update then [:edit]
              when :destroy, :delete then %i[destroy delete]
              else [action_name.to_sym]
              end

    return if actions.map { |a| permissions&.dig(resource, a) }.any?(true)

    raise AuthorizationError
  end
  # rubocop:enable  Metrics/CyclomaticComplexity
end
