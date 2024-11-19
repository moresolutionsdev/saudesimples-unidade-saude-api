# frozen_string_literal: true

module Rescueable
  extend ActiveSupport::Concern

  included do |base|
    base.rescue_from(ActionController::ParameterMissing) { |e| render_400(e.message) }

    base.rescue_from(ActiveRecord::RecordNotFound) { |e| render_404(e.message) }

    base.rescue_from(ActiveRecord::RecordInvalid) { |e| render_422(e.message) }
  end
end
