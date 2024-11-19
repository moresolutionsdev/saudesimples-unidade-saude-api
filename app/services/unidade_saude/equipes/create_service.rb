# frozen_string_literal: true

class UnidadeSaude
  module Equipes
    class CreateService < ApplicationService
      def initialize(params)
        @params = params
      end

      def call
        equipe = ::UnidadeSaude::EquipeRepository.create!(@params)

        success(equipe)
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new(e.message)
      end
    end
  end
end
