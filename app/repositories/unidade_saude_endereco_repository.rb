# frozen_string_literal: true

class UnidadeSaudeEnderecoRepository < ApplicationRepository
  def self.estados_habilidados(codigo_esus = Pais::BRASIL_CODIGO_ESUS)
    pais_id = Pais.find_by(codigo_esus:)&.id

    return [] unless pais_id

    Estado.where(pais_id:).order(:nome)
  end

  def self.search_municipio_ibge(ibge)
    Municipio.find_by(ibge:)
  end

  def self.find_estado_by_id(id)
    Estado.find_by(id:)
  end

  def self.find_logradouro_by_municipio_and_nome(municipio_id, nome)
    Logradouro.joins(:municipio).where(municipios: { id: municipio_id }, nome:).first
  end

  def self.search_locais(nome)
    Local.where('nome ILIKE ?', "%#{nome}%").order(nome: :asc)
  end

  def self.tipo_logradouro
    TipoLogradouro.all
  end

  def self.find_by_id(id)
    Municipio.find_by(id:)
  end
end
