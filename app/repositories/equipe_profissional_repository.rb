# frozen_string_literal: true

class EquipeProfissionalRepository < ApplicationRepository
  class << self
    delegate_missing_to EquipeProfissional

    def search(params = {})
      equipe_profissionais = base_query

      equipe_profissionais = apply_filters(params, equipe_profissionais)

      equipe_profissionais.order(build_order_clause(params))
    end

    private

    def apply_filters(params, equipe_profissionais)
      equipe_profissionais = filter_by_profissional_id(equipe_profissionais, params[:profissional_id])
      equipe_profissionais = filter_by_equipe_id(equipe_profissionais, params[:equipe_id])
      equipe_profissionais = filter_by_nome_profissional(equipe_profissionais, params[:nome_profissional])
      equipe_profissionais = filter_by_nome_ocupacao(equipe_profissionais, params[:nome_ocupacao])
      equipe_profissionais = filter_by_codigo_micro_area(equipe_profissionais, params[:codigo_micro_area])
      equipe_profissionais = filter_by_entrada(equipe_profissionais, params[:entrada])
      filter_by_data_saida(equipe_profissionais, params[:data_saida])
    end

    def base_query
      includes(:profissional, :ocupacao)
    end

    def filter_by_profissional_id(equipe_profissionais, profissional_id)
      return equipe_profissionais if profissional_id.blank?

      equipe_profissionais.where(profissional_id:)
    end

    def filter_by_equipe_id(equipe_profissionais, equipe_id)
      return equipe_profissionais if equipe_id.blank?

      equipe_profissionais.where(equipe_id:)
    end

    def filter_by_nome_profissional(equipe_profissionais, nome_profissional)
      return equipe_profissionais if nome_profissional.blank?

      equipe_profissionais.joins(:profissional).where('profissionais.nome ILIKE ?', "%#{nome_profissional}%")
    end

    def filter_by_nome_ocupacao(equipe_profissionais, nome_ocupacao)
      return equipe_profissionais if nome_ocupacao.blank?

      equipe_profissionais.joins(:ocupacao).where('ocupacoes.nome ILIKE ?', "%#{nome_ocupacao}%")
    end

    def filter_by_codigo_micro_area(equipe_profissionais, codigo_micro_area)
      return equipe_profissionais if codigo_micro_area.blank?

      equipe_profissionais.where(codigo_micro_area:)
    end

    def filter_by_entrada(equipe_profissionais, entrada)
      return equipe_profissionais if entrada.blank?

      equipe_profissionais.where('DATE(entrada) = ?', entrada)
    end

    def filter_by_data_saida(equipe_profissionais, data_saida)
      return equipe_profissionais if data_saida.blank?

      equipe_profissionais.where('DATE(data_saida) = ?', data_saida)
    end

    def build_order_clause(params)
      order_column = params[:order] || 'profissional_nome'
      direction = params[:order_direction] || 'asc'

      order_by = case order_column
                 when 'ocupacao_nome'
                   'ocupacoes.nome'
                 when 'codigo_micro_area'
                   'codigo_micro_area'
                 else
                   'profissionais.nome'
                 end

      "#{order_by} #{direction}"
    end
  end
end
