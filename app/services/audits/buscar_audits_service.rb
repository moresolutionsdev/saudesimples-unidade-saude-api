# frozen_string_literal: true

module Audits
  class BuscarAuditsService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      @relation = ::AuditsRepository.search(@params)

      Success.new(@relation)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar audits')
    end
  end
end
