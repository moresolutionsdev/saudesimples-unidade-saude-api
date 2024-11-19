# frozen_string_literal: true

class GrupoAtendimentoRepository < ApplicationRepository
  def self.filter(params)
    query = GrupoAtendimento.includes(:unidade_saude, :profissional)

    query = query.where(profissional_id: params[:profissional_id]) if params[:profissional_id].present?
    query = query.where('nome ILIKE ?', "%#{params[:search_term]}%") if params[:search_term].present?
    query = query.where(unidade_saude_id: params[:unidade_saude_id]) if params[:unidade_saude_id].present?

    query.all
  end
end
