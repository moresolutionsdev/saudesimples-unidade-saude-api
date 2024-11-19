# frozen_string_literal: true

class EquipeRepository < ApplicationRepository
  class << self
    delegate_missing_to Equipe

    CNES_URL = Rails.configuration.env_params.importacao_cnes_api_url

    def search(params = {})
      equipes = base_query

      equipes = filter_by_unidade_saude(equipes, params[:unidade_saude_id])
      equipes = filter_by_term(equipes, params[:term])
      equipes = filter_by_tipo_equipe_descricao(equipes, params[:tipo_equipe_descricao])

      equipes.order(build_order_clause(params))
    end

    def search_minimal(params = {})
      equipes = Equipe.select(:id, :nome, :codigo)
      if params[:term].present?
        term = "%#{params[:term]}%"
        equipes = equipes.where('nome LIKE :term OR CAST(codigo AS TEXT) LIKE :term', term:)
      end
      equipes.order(:nome)
    end

    def list_from_cnes(page: 1)
      url = "#{CNES_URL}/api/v1/equipes?page=#{page}"
      parse_json(get(url:)).dig(:data, :equipes)
    end

    private

    def base_query
      includes(:tipo_equipe, :categoria_equipe, :area_relacionada)
        .joins(:tipo_equipe, 'LEFT JOIN areas ON areas.codigo = equipes.area')
    end

    def filter_by_unidade_saude(equipes, unidade_saude_id)
      return equipes if unidade_saude_id.blank?

      equipes.where(unidade_saude_id:)
    end

    def filter_by_term(equipes, term)
      return equipes if term.blank?

      term = "%#{term.strip}%"
      equipes.where(
        <<-SQL.squish,
          REPLACE(equipes.nome, ' ', '') ILIKE REPLACE(?, ' ', '') OR
          REPLACE(equipes.codigo::text, ' ', '') ILIKE REPLACE(?, ' ', '') OR
          REPLACE(areas.nome, ' ', '') ILIKE REPLACE(?, ' ', '') OR
          REPLACE(tipos_equipes.descricao, ' ', '') ILIKE REPLACE(?, ' ', '')
        SQL
        term, term, term, term
      )
    end

    def filter_by_tipo_equipe_descricao(equipes, tipo_equipe_descricao)
      return equipes if tipo_equipe_descricao.blank?

      equipes.where('tipos_equipes.descricao ILIKE ?', "%#{tipo_equipe_descricao}%")
    end

    def build_order_clause(params)
      order_column = params[:order] || 'nome'
      direction = params[:order_direction] || 'asc'

      case order_column
      when 'tipo_equipe'
        "tipos_equipes.descricao #{direction}, tipos_equipes.id #{direction}"
      when 'situacao'
        "CASE WHEN equipes.data_desativacao IS NULL THEN 0 ELSE 1 END #{direction}, equipes.nome #{direction}"
      else
        "equipes.#{order_column} #{direction}"
      end
    end
  end
end
