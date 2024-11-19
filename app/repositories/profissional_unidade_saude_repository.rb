# frozen_string_literal: true

class ProfissionalUnidadeSaudeRepository < ApplicationRepository
  def self.by_nome_profissional(unidade_saude_id, nome)
    ProfissionalUnidadeSaude
      .joins(:profissional)
      .where(unidade_saude_id:)
      .where('profissionais.nome ILIKE ?', "%#{nome}%")
  end

  def self.by_nome_ocupacao(unidade_saude_id, nome)
    ProfissionalUnidadeSaude
      .joins(:ocupacao)
      .where(unidade_saude_id:)
      .where('ocupacoes.nome ILIKE ?', "%#{nome}%")
  end

  def self.by_cpf_profissional(unidade_saude_id, term)
    ProfissionalUnidadeSaude
      .joins(:profissional)
      .where(unidade_saude_id:)
      .where("regexp_replace(cpf_numero, '[^0-9]', '', 'g') LIKE ?", "%#{term.gsub(/[^\d]/, '')}%")
  end

  def self.by_search_term(unidade_saude_id, term)
    query = 'profissionais.nome ILIKE :term OR ocupacoes.nome ILIKE :term'
    cleaned_term = term.gsub(/[^0-9]/, '')

    if cleaned_term.present?
      query += ' OR regexp_replace(profissionais.cpf_numero, \'[^0-9]\', \'\', \'g\') LIKE :cleaned_term
      OR profissionais.cpf_numero ILIKE :term
      OR regexp_replace(profissionais.codigo_cns, \'[^0-9]\', \'\', \'g\') LIKE :term'
    end

    ProfissionalUnidadeSaude
      .joins(:profissional)
      .where(unidade_saude_id:)
      .where(
        query,
        cleaned_term: "%#{cleaned_term}%",
        term: "%#{term}%"
      )
  end

  def self.sanitize_cpf_cnpj(term)
    term.gsub(/[^d]/, '')
  end
end
