# frozen_string_literal: true

class AuditsRepository < ApplicationRepository
  class << self
    def search(params = {})
      audits = ::Audited::Audit.all

      audits = filter_by_term(audits, params[:term])
      audits = filter_by_dates(audits, params[:date_start], params[:date_end])
      audits = filter_by_auditable_type(audits, params[:auditable])

      audits = audits.order(build_order_clause(params))
      audits.page(params[:page]).per(params[:per_page])
    end

    def filter_by_term(audits, term)
      return audits if term.blank?

      Rails.logger.info("Aplicando filtro pelo termo: #{term}")

      audits = apply_association_joins(audits)

      audits.where('usuarios.email ILIKE :term_exact OR profissionais.nome ILIKE :term_exact', term_exact: "%#{term}%")
    end

    private

    def apply_association_joins(audits)
      audits.joins("
        LEFT JOIN usuarios ON usuarios.id = audits.user_id AND audits.user_type = 'Usuario'
        LEFT JOIN profissionais ON profissionais.id = usuarios.profissional_id
      ")
    end

    def filter_by_auditable_type(audits, auditable)
      return audits if auditable.blank?

      audits.where('auditable_type LIKE ?', auditable.to_s)
    end

    def filter_by_dates(audits, date_start, date_end)
      return audits if date_start.blank? && date_end.blank?

      if date_end.blank?
        audits.where('DATE(audits.created_at) > ?', date_start)
      else
        audits.where('DATE(audits.created_at) BETWEEN ? AND ?', date_start, date_end)
      end
    end

    def build_order_clause(params)
      default_order_field = params[:term].present? ? 'audits.created_at' : 'created_at'
      default_order_direction = 'asc'

      order_column = default_order_field
      direction = params[:order_direction] || default_order_direction

      "#{order_column} #{sanitize_direction(direction)}"
    end

    def sanitize_direction(direction)
      %w[asc desc].include?(direction.downcase) ? direction : 'asc'
    end
  end
end
