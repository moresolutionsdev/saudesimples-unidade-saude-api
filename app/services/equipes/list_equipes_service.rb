# frozen_string_literal: true

module Equipes
  class ListEquipesService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      equipes = EquipeRepository.search_minimal(@params)
      Success.new(equipes)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new('Erro ao listar Equipes')
    end
  end
end
