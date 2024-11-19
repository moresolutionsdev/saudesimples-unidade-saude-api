# frozen_string_literal: true

class UnidadeSaude
  module Equipes
    class UpdateService < ApplicationService
      def initialize(params, scope:)
        @id = params[:id]
        @params = params
        @scope = scope
      end

      def call
        equipe = scoped_records.find(@id)
        equipe.update!(@params)

        success(equipe)
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new(e.message)
      end

      private

      def scoped_records
        ::UnidadeSaude::EquipeRepository.where(@scope)
      end
    end
  end
end
