# frozen_string_literal: true

module Equipes
  class DetalharService < ApplicationService
    def initialize(params)
      @id = params[:id]
    end

    def call
      equipe = ::EquipeRepository.find(@id)

      if equipe.present?
        Success.new(equipe)
      else
        Failure.new('Equipe não encontrada')
      end
    end

    private

    attr_reader :id
  end
end
