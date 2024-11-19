# frozen_string_literal: true

class UnidadeSaude
  class ListaInstalacoesUnidadeSaudeService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      instalacoes = ::InstalacaoUnidadeSaude.includes(:unidade_saude)
      filter_by_params(instalacoes)
      order(instalacoes)
      Success.new(paginate(instalacoes))
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new('Erro ao listar instalações da unidade de saúde')
    end

    private

    attr_reader :params

    def filter_by_params(instalacoes)
      return if params[:nome].blank?

      instalacoes.where('instalacao_unidades_saudes.nome ILIKE ?', "%#{params[:nome]}%")
    end

    def order(instalacoes)
      direction = params[:order_direction] || 'asc'
      order = params[:order] || 'default_order_column'
      instalacoes.order("#{order} #{direction}")
    end

    def paginate(instalacoes)
      page = params[:page] || 1
      per_page = params[:per_page] || 10
      instalacoes.page(page).per(per_page)
    end
  end
end
