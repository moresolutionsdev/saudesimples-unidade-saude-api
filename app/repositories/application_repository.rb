# frozen_string_literal: true

class ApplicationRepository
  extend HttpClient
  extend ::CurrentUser
  include ::CurrentUser

  private_class_method :new
end
