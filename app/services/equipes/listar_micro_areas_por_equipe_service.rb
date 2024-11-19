# frozen_string_literal: true

module Equipes
  class ListarMicroAreasPorEquipeService < ApplicationService
    def initialize(id, params)
      @params = params
      @id = id
    end

    def call
      micro_areas = MicroAreaRepository.search_by_equipe(@id, @params)

      success(micro_areas)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end
  end
end
