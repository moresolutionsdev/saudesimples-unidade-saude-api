# frozen_string_literal: true

class PoliticaAcessoRepository < ApplicationRepository
  class << self
    delegate_missing_to TermoUso

    def self.create!(params)
      TermoUso.create!(params)
    end

    def search(params = {})
      termos = TermoUso.where(documento_tipo: :politica_acesso)
      titulo = params[:nome_arquivo]
      termos = termos.where('titulo ILIKE ?', "%#{titulo}%") if params[:nome_arquivo].present?
      termos = termos.where('DATE(created_at) = ?', params[:data_criacao]) if params[:data_criacao].present?
      if params[:email_usuario].present?
        termos = termos.joins(:usuario).where('usuarios.email ILIKE ?', "%#{params[:email_usuario]}%")
      end

      termos
    end

    def last_version
      TermoUso.where(documento_tipo: :politica_acesso).order(versao: :desc).first
    end
  end
end
