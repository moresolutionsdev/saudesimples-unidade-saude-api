# frozen_string_literal: true

class StatusController < ApplicationController
  def index
    render(
      json: StatusService.call,
      status: :ok
    )
  end
end
