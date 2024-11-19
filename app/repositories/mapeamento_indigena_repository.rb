# frozen_string_literal: true

class MapeamentoIndigenaRepository < ApplicationRepository
  class << self
    delegate_missing_to MapeamentoIndigena

    def search(params = {})
      records = MapeamentoIndigena.all

      if params[:search_term].present?
        term = params[:search_term]
        records = records.where('codigo_dsei ILIKE ? OR dsei ILIKE ? OR polo_base ILIKE ? OR aldeia ILIKE ?',
                                "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%")
      end

      records.order(params.fetch(:sort_by, :aldeia) => params.fetch(:sort_direction, :asc))
    end
  end
end
