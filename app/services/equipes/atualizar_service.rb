# frozen_string_literal: true

module Equipes
  class AtualizarService < ApplicationService
    def initialize(params)
      @id = params[:id]
      @params = params
    end

    def call
      equipe = ::EquipeRepository.find(@id)
      equipe.update!(@params)

      success(equipe)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end
  end
end
