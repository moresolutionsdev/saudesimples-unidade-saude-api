# frozen_string_literal: true

module TermosUso
  class ListTermosUsosService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      load_termos
      paginate
      sort

      Success.new(@termos)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar Termo de uso')
    end

    private

    def load_termos
      @termos = TermoUsoRepository.search(search_params)
    end

    def paginate
      page = @params[:page] || 1
      per_page = @params[:per_page] || 10

      @termos = @termos.page(page).per(per_page)
    end

    def sort
      order = @params[:order] || 'titulo'
      direction = @params[:order_direction] || 'asc'

      @termos = @termos.order("#{order} #{direction}")
    end

    def search_params
      @params.slice(:nome_arquivo, :data_criacao, :email_usuario)
    end
  end
end
