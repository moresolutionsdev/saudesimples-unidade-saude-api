# frozen_string_literal: true

module PoliticasAcesso
  class ListPoliticasAcessoService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      load_termos
      paginate
      sort

      Success.new(@politicas)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar Politicas de Acesso')
    end

    private

    def load_termos
      @politicas = PoliticaAcessoRepository.search(search_params)
    end

    def paginate
      page = @params[:page] || 1
      per_page = @params[:per_page] || 10

      @politicas = @politicas.page(page).per(per_page)
    end

    def sort
      order = @params[:order] || 'titulo'
      direction = @params[:order_direction] || 'asc'

      @politicas = @politicas.order("#{order} #{direction}")
    end

    def search_params
      @params.slice(:nome_arquivo, :data_criacao, :email_usuario)
    end
  end
end
