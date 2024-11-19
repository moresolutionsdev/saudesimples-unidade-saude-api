# frozen_string_literal: true

class TipoEquipeRepository < ApplicationRepository
  class << self
    delegate_missing_to TipoEquipe

    def search(params = {})
      query = all
      query = query.where('sigla ILIKE ?', "%#{params[:sigla]}%") if params[:sigla].present?
      query = query.where('descricao ILIKE ?', "%#{params[:descricao]}%") if params[:descricao].present?
      query
    end
  end
end
