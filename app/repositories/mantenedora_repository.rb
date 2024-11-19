# frozen_string_literal: true

class MantenedoraRepository < ApplicationRepository
  def self.find_or_initialize_by(unidade_saude_id:)
    Mantenedora.find_or_initialize_by(unidade_saude_id:)
  end

  def self.update(mantenedora:, params:)
    mantenedora.update!(params)
  end

  def self.create(params)
    mantenedora = Mantenedora.new(params)
    raise ActiveRecord::RecordInvalid, mantenedora.errors.full_messages.join(', ') unless mantenedora.save

    mantenedora
  end
end
