# frozen_string_literal: true

module Areas
  class ListarAreaService < ApplicationService
    def initialize(params)
      @params = params
    end

    attr_reader :params

    def call
      areas = ::AreaRepository.search(params)
      Success.new(areas)
    rescue StandardError => e
      Rails.logger.error(e.message)
      Failure.new('Falha ao listar áreas')
    end
  end
end
