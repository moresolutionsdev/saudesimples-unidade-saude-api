# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ::Renderable
  include ::Rescueable
  include ::Authenticable
  include ::Authorizable
  include ::Serializable

  def pagination_params
    page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    per_page = params[:per_page].to_i.zero? ? 10 : params[:per_page].to_i

    { page:, per_page: }
  end
end
