# frozen_string_literal: true

class ApplicationService
  extend ::CurrentUser
  include ::CurrentUser

  def self.call(...)
    new(...).call
  end

  def call
    raise NotImplementedError, 'You must implement the call method'
  end

  def success(data)
    Success.new(data)
  end

  def failure(error)
    Failure.new(error)
  end
end

class Success
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def success?
    true
  end

  def failure?
    false
  end

  def deconstruct_keys(*)
    { success: data }
  end
end

class Failure
  attr_reader :error

  def initialize(error)
    @error = error
  end

  def success?
    false
  end

  def failure?
    true
  end

  def deconstruct_keys(*)
    { failure: error }
  end
end
