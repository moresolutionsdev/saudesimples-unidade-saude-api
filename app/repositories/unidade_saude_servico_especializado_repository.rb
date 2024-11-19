# frozen_string_literal: true

class UnidadeSaudeServicoEspecializadoRepository < ApplicationRepository
  DEFAULT_ORDER = 'servicos.nome'
  ALLOWED_ORDERS = {
    'tipo_servico' => 'servicos.nome',
    'classificacao' => 'servicos_classificacoes.classificacao'
  }.freeze
  ALLOWED_DIRECTIONS = %w[asc desc].freeze

  def self.all(params)
    order_direction = params[:order_direction].downcase
    order_field = ALLOWED_ORDERS[params[:order]] || DEFAULT_ORDER
    direction = order_direction.in?(ALLOWED_DIRECTIONS) ? order_direction : 'asc'
    per_page = params[:per_page] || 10

    scope = ServicoUnidadeSaude.includes(:classificacao).joins(:servico, :caracteristica_servico)
    scope = scope.where(unidade_saude_id: params[:unidade_saude_id]) if params[:unidade_saude_id]
    scope.order("#{order_field} #{direction}").page(params[:page]).per(per_page)
  end
end
