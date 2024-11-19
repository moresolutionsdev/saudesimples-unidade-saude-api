# frozen_string_literal: true

module MapeamentoIndigenas
  class ListMapeamentoIndigenasService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      load_mapeamento_indigenas
      paginate

      Success.new(@mapeamento_indigenas)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao listar Mapeamento indigenas')
    end

    private

    def load_mapeamento_indigenas
      @mapeamento_indigenas = MapeamentoIndigenaRepository.search(search_params)
    end

    def paginate
      page = @params[:page] || 1
      per_page = @params[:per_page] || 10

      @mapeamento_indigenas = @mapeamento_indigenas.page(page).per(per_page)
    end

    def search_params
      @params.slice(:search_term)
    end
  end
end
