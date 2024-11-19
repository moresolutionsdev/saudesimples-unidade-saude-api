# frozen_string_literal: true

module TipoEquipes
  class ListTipoEquipesService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      load_tipo_equipes
      paginate

      Success.new(@tipo_equipes)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao listar Tipo de Equipes')
    end

    private

    def load_tipo_equipes
      @tipo_equipes = TipoEquipeRepository.search(search_params).order(:sigla)
    end

    def paginate
      page = @params[:page] || 1
      per_page = @params[:per_page] || 10

      @tipo_equipes = @tipo_equipes.page(page).per(per_page)
    end

    def search_params
      @params.slice(:sigla, :descricao)
    end
  end
end
