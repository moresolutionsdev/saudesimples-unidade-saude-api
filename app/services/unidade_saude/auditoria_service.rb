# frozen_string_literal: true

class UnidadeSaude
  class AuditoriaService < ApplicationService
    def initialize(unidade_saude_id, params)
      @unidade_saude_id = unidade_saude_id
      @params = params
      @page = params[:page] || 1
      @per_page = params[:per_page] || 10
      @order = params[:order] || 'created_at'
      @order_direction = params[:order_direction] || 'asc'
      @date_start = parse_datetime(params[:date_start])
      @date_end = parse_datetime(params[:date_end])
    end

    def call
      unidade_saude = UnidadeSaude.find_by(id: @unidade_saude_id)
      return Failure.new('Unidade de Saúde não encontrada') unless unidade_saude

      audits = unidade_saude.audits
        .preload(:auditable)
        .reorder("#{@order} #{@order_direction}")

      audits = apply_filters(audits)
      paginated_audits = paginate(audits)

      Success.new(paginated_audits)
    rescue StandardError
      Failure.new('Erro ao listar auditoria da unidade de saúde')
    end

    private

    def apply_filters(audits)
      audits = AuditsRepository.filter_by_term(audits, @params[:term]) if @params[:term].present?
      audits = audits.where(created_at: @date_start..) if @date_start.present?
      audits = audits.where(created_at: ..@date_end) if @date_end.present?
      audits
    end

    def paginate(audits)
      audits.page(@page).per(@per_page)
    end

    def parse_datetime(date_string)
      return nil if date_string.blank?

      begin
        DateTime.parse(date_string)
      rescue StandardError
        Rails.logger.warn("Data inválida recebida: #{date_string}")
        nil
      end
    end
  end
end
