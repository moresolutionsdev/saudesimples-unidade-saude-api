# frozen_string_literal: true

# Serviço para buscar e listar unidades de saúde com filtros e paginação.
class UnidadeSaude
  class SearchService < ApplicationService
    attr_accessor :unidades_saude

    FILTER_SCOPES = {
      'ativa' => :ativas,
      'inativa' => :inativas,
      'ativas' => :ativas,
      'inativas' => :inativas,
      'active' => :ativas,
      'inactive' => :inativas
    }.freeze

    ORDER_SCOPES = {
      'nome' => :order_by_name,
      'situacao' => :order_by_status
    }.freeze

    def initialize(params)
      @params = params
    end

    def call
      @unidades_saude = ::UnidadeSaudeRepository.all

      apply_filters
      apply_order
      paginate

      Success.new({
        unidades_saude: @unidades_saude,
        total_pages: @unidades_saude.total_pages,
        total_count: @unidades_saude.total_count,
        current_page: @params[:page]
      })
    rescue StandardError => e
      Failure.new(e)
    end

    private

    def apply_filters
      @unidades_saude = ::UnidadeSaudeRepository.search_by_term(@params[:term]) if @params[:term].present?

      @unidades_saude = ::UnidadeSaudeRepository.search_by_cnes(@params[:cnes]) if @params[:cnes].present?

      return unless @params[:situacao].present? && FILTER_SCOPES.key?(@params[:situacao])

      @unidades_saude = @unidades_saude.public_send(FILTER_SCOPES[@params[:situacao]])
    end

    def apply_order
      order_direction = @params[:order_direction].presence || 'asc'

      return unless @params[:order].present? && ORDER_SCOPES.key?(@params[:order])

      order_direction = order_direction.to_sym if order_direction.is_a?(String)
      @unidades_saude = @unidades_saude.public_send(ORDER_SCOPES[@params[:order]], order_direction)
    end

    def paginate
      @unidades_saude = @unidades_saude.page(@params[:page]).per(@params[:per_page])
    end
  end
end
