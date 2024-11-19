# frozen_string_literal: true

module Instalacao
  class BuscarInstalacaoFisicaService < ApplicationService
    def initialize(params)
      @params = params
    end
    attr_reader :params

    def call
      instalacao_fisica = ::InstalacaoFisicaRepository.find_by_id_or_name(params) # rubocop:disable Rails/DynamicFindBy

      Success.new(instalacao_fisica)
    rescue StandardError => e
      Rails.logger.error(e.message)

      Failure.new('Falha ao buscar instalação física')
    end
  end
end
