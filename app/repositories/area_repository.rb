# frozen_string_literal: true

class AreaRepository < ApplicationRepository
  class << self
    def search(params = {})
      areas = Area.all

      areas = filter_by_nome(areas, params[:nome])
      areas = filter_by_codigo(areas, params[:codigo])
      areas = filter_by_municipio(areas, params[:municipio_id])
      areas = filter_by_segmento(areas, params[:segmento_id])

      areas = areas.order(build_order_clause(params))
      areas.page(params[:page]).per(params[:per_page])
    end

    private

    def filter_by_nome(areas, nome)
      return areas if nome.blank?

      areas.where('nome ILIKE ?', "%#{nome}%")
    end

    def filter_by_codigo(areas, codigo)
      return areas if codigo.blank?

      areas.where(codigo:)
    end

    def filter_by_municipio(areas, municipio_id)
      return areas if municipio_id.blank?

      areas.where(municipio_id:)
    end

    def filter_by_segmento(areas, segmento_id)
      return areas if segmento_id.blank?

      areas.where(segmento_id:)
    end

    def build_order_clause(params)
      order_column = params[:order] || 'nome'
      direction = params[:order_direction] || 'asc'

      "#{sanitize_order_column(order_column)} #{sanitize_direction(direction)}"
    end

    def sanitize_order_column(column)
      allowed_columns = %w[nome codigo municipio_id segmento_id]
      allowed_columns.include?(column) ? column : 'nome'
    end

    def sanitize_direction(direction)
      %w[asc desc].include?(direction) ? direction : 'asc'
    end
  end
end
