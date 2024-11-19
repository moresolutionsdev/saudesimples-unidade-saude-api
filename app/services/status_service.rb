# frozen_string_literal: true

class StatusService < ApplicationService
  TIMEOUT_SECONDS = 3

  def call
    {
      status: status?,
      database: {
        active: database_active?,
        accept_connection: database_accept_connection?,
        pending_migration: pending_migration?
      }
    }
  end

  private

  def database_active?
    return @database_active unless @database_active.nil?

    begin
      @database_active = Timeout.timeout(TIMEOUT_SECONDS) { ActiveRecord::Base.connection.active? }
    rescue Timeout::Error
      @database_active = false
    end

    @database_active
  end

  def database_accept_connection?
    @database_accept_connection ||= ActiveRecord::Base.connection.execute('select 1').present?
  end

  def pending_migration?
    @pending_migration ||= ActiveRecord::Migration.check_pending_migrations
  end

  def status?
    @status ||= database_active? && database_accept_connection?
  end
end
