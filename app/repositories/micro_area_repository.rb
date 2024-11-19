# frozen_string_literal: true

class MicroAreaRepository < ApplicationRepository
  class << self
    def search(params = {})
      micro_areas = MicroArea.all

      micro_areas = filter_by_nome(micro_areas, params[:nome])
      micro_areas = filter_by_codigo(micro_areas, params[:codigo])
      micro_areas = filter_by_area(micro_areas, params[:area_id])

      micro_areas.order(build_order_clause(params))
    end

    def search_by_equipe(equipe_id, params = {})
      scope = MicroArea.joins(:equipes).where(equipes: { id: equipe_id })
      if params[:term].present?
        scope = scope.where('micro_areas.nome ILIKE ? OR micro_areas.codigo::text ILIKE ?', "%#{params[:term]}%",
                            "%#{params[:term]}%")
      end
      scope.order(nome: :asc)
    end

    private

    def filter_by_nome(micro_areas, nome)
      return micro_areas if nome.blank?

      micro_areas.where('nome ILIKE ?', "%#{nome}%")
    end

    def filter_by_codigo(micro_areas, codigo)
      return micro_areas if codigo.blank?

      micro_areas.where(codigo:)
    end

    def filter_by_area(micro_areas, area_id)
      return micro_areas if area_id.blank?

      micro_areas.where(area_id:)
    end

    def build_order_clause(params)
      order_column = params[:order] || 'nome'
      direction = params[:order_direction] || 'asc'

      "#{order_column} #{direction}"
    end
  end
end
