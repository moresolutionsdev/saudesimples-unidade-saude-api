# frozen_string_literal: true

module Equipes
  class UpsertService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      # rubocop:disable Rails/SkipsModelValidations
      equipe = ::EquipeRepository.upsert_all(upsert_params, unique_by: :codigo, on_duplicate: :skip)
      # rubocop:enable Rails/SkipsModelValidations

      success(equipe)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end

    private

    def upsert_params
      @params.map do |hash|
        {
          tipo_equipe_id: find_tipo_equipe_by_codigo(hash[:tipo_equipe])&.id,
          unidade_saude_id: hash[:unidade_saude_id],
          area: hash[:codigo_area],
          codigo: hash[:codigo_ine],
          data_desativacao: hash[:data_desativacao],
          data_ativacao: hash[:created_at],
          nome_referencia: hash[:nome_referencia]
        }
      end
    end

    def find_tipo_equipe_by_codigo(codigo)
      ::TipoEquipeRepository.find_by(codigo:)
    end
  end
end
