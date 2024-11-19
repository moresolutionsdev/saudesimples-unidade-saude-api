# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.inherited(subclass)
    super
    subclass.primary_key = 'id'
  end
end
