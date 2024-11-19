# frozen_string_literal: true

module Agendas
  class ListarTiposBloqueiosService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      Success.new(listar_tipos_de_bloqueios)
    rescue StandardError => e
      Rails.logger.error(e.message)

      Failure.new('Falha ao listar tipo de bloqueios para agenda')
    end

    private

    attr_reader :params

    def listar_tipos_de_bloqueios
      tipo_de_bloqueios = TipoBloqueio.all
      search_term = params[:search_term]

      return tipo_de_bloqueios if search_term.blank?

      tipo_de_bloqueios.where('nome ILIKE ?', "%#{search_term}%")
    end
  end
end
