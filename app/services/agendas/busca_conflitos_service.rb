# frozen_string_literal: true

module Agendas
  class BuscaConflitosService < ApplicationService
    attr_reader :profissional_id, :unidade_saude_id, :data_inicial, :data_final

    def initialize(params)
      @profissional_id = params[:profissional_id]
      @unidade_saude_id = params[:unidade_saude_id]
      @data_inicial = params[:data_inicial]
      @data_final = params[:data_final]
    end

    def call
      validate_params!
      busca_conflitos

      conflitos = busca_conflitos

      Success.new(conflitos)
    rescue ArgumentError => e
      Rails.logger.error(e.message)
      Failure.new({ error: e.message, status: 400 })
    rescue StandardError => e
      Rails.logger.error(e.message)

      Failure.new({ error: 'Não foi possível buscar os conflitos de agenda.' })
    end

    private

    def validate_params!
      return unless profissional_id.blank? || data_inicial.blank? || data_final.blank?

      raise ArgumentError,
            'Profissional, Data Inicial e Data Final são obrigatórios.'
    end

    def busca_conflitos
      AgendaMapaPeriodoRepository.buscar_conflitos(
        profissional_id:,
        unidade_saude_id:,
        data_inicial:,
        data_final:
      )
    end
  end
end
