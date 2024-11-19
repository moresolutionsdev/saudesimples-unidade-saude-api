# frozen_string_literal: true

class UnidadeSaude
  class EquipeRepository < ApplicationRepository
    class << self
      delegate_missing_to Equipe

      def search(params)
        equipes = base_scope(params)
        equipes = apply_filters(equipes, params)
        equipes = apply_order(equipes, params)
        apply_pagination(equipes, params)
      end

      def find_equipe_by_unidade(unidade_saude_id, equipe_id)
        includes(:tipo_equipe, :categoria_equipe)
          .where(unidade_saude_id:, id: equipe_id)
          .first
      end

      private

      def base_scope(params)
        includes(:tipo_equipe, :categoria_equipe, :area_relacionada)
          .left_joins(:tipo_equipe, :categoria_equipe, :area_relacionada)
          .where(unidade_saude_id: params[:unidade_saude_id])
      end

      def apply_filters(equipes, params)
        equipes = filter_by_term(equipes, params[:term]) if params[:term].present?
        equipes = filter_by_situacao(equipes, params[:situacao]) if params[:situacao].present?
        equipes
      end

      def filter_by_term(equipes, term)
        term = "%#{term.downcase}%"
        equipes.where(
          'LOWER(equipes.nome) LIKE ?
           OR LOWER(equipes.codigo::text) LIKE ?
           OR LOWER(areas.nome) LIKE ? OR LOWER(tipos_equipes.sigla) LIKE  ?
           OR CAST(equipes.area AS TEXT) LIKE ? OR LOWER(tipos_equipes.descricao) LIKE  ?',
          term, term, term, term, term, term
        )
      end

      def filter_by_situacao(equipes, situacao)
        if situacao == 'ativa'
          equipes.where(data_desativacao: nil)
        elsif situacao == 'inativa'
          equipes.where.not(data_desativacao: nil)
        else
          equipes
        end
      end

      def apply_order(equipes, params)
        order_clause = build_order_clause(params[:order], params[:order_direction])
        equipes.order(order_clause)
      end

      def apply_pagination(equipes, params)
        if params[:page] && params[:per_page]
          equipes.page(params[:page]).per(params[:per_page])
        else
          equipes
        end
      end

      def build_order_clause(order_param, order_direction)
        direction = order_direction || 'asc'
        order_sql = case order_param
                    when 'tipo_equipe'
                      "tipos_equipes.sigla #{direction}, equipes.nome #{direction}"
                    when 'situacao'
                      "CASE WHEN equipes.data_ativacao IS NULL THEN 0 ELSE 1 END #{direction},
                       equipes.nome #{direction}"
                    else
                      "equipes.#{order_param || 'nome'} #{direction}"
                    end
        Arel.sql(order_sql)
      end
    end
  end
end
