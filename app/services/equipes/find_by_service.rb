# frozen_string_literal: true

module Equipes
  class FindByService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      equipe = ::EquipeRepository.find_by(@params)

      if equipe.present?
        success(equipe)
      else
        failure('Equipe não encontrada')
      end
    rescue StandardError => e
      Rails.logger.error(e)
      failure("Erro ao buscar Equipe: #{e}")
    end
  end
end
