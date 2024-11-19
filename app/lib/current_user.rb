# frozen_string_literal: true

module CurrentUser
  extend ActiveSupport::Concern

  def current_user
    Current.user
  end
end
