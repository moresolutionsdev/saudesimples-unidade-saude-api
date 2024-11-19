# frozen_string_literal: true

module Equipes
  class CriarService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      equipe = ::EquipeRepository.create!(@params)

      success(equipe)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end
  end
end
