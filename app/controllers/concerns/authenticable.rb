# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  include ::AutenticacaoGem::Authenticable

  class CurrentUserNotFoundError < StandardError; end

  included do |base|
    base.rescue_from CurrentUserNotFoundError, with: lambda {
      render_412('O Usuário autenticado no token não foi encontrado na base de dados.')
    }

    base.before_action :authenticate_token!
    base.before_action :authenticate_user!
  end

  def authenticate_user!
    set_current_user
  end

  def current_user
    ::Current.user ||= set_current_user
  end

  protected

  def set_current_user
    ::Current.user ||= ::Usuario.find(authenticated_user[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error(e)
    raise CurrentUserNotFoundError
  end
end
