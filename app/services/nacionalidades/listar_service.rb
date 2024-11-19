# frozen_string_literal: true

module Nacionalidades
  class ListarService < ApplicationService
    def call
      nacionalidades = NacionalidadeRepository.all

      success(nacionalidades)
    rescue StandardError => e
      Rails.logger.error(e)

      failure(e.message)
    end
  end
end
