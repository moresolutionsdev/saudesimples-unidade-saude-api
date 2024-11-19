# frozen_string_literal: true

class HealthCheckController < ApplicationController
  rescue_from(Exception) { render json: { status: 'down' }, status: :internal_server_error }

  def show
    return render json: { status: 'down' }, status: :internal_server_error if !check_connection && check_migration

    render json: { status: 'up' }, status: :ok
  end

  def check_connection
    ActiveRecord::Base.connection.execute('select 1').present?
  end

  def check_migration
    ActiveRecord::Migration.check_all_pending! ? true : false
  end
end
