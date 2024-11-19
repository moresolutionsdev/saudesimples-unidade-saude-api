# frozen_string_literal: true

class UnidadeSaude
  class SearchSubtipoUnidadeService < ApplicationService
    def initialize(classificacao_cnes_id:)
      @classificacao_cnes_id = classificacao_cnes_id
    end

    def call
      subtipo_unidades = DescricaoSubtipoUnidadeRepository.search_by_classificacao(@classificacao_cnes_id)
      Success.new(subtipo_unidades)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new('Erro ao buscar subtipos de unidades de saúde')
    end
  end
end
