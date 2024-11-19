# frozen_string_literal: true

class InstalacaoFisicaRepository < ApplicationRepository
  def self.find_by_id_or_name(params)
    query = ::InstalacaoFisica.includes(:subtipo_instalacao, :tipo_instalacao_fisica)
    query = query.where(id: params[:id]) if params[:id].present?
    query = query.where('nome ILIKE ?', "%#{params[:nome]}%") if params[:nome].present?
    query.all
  end
end
