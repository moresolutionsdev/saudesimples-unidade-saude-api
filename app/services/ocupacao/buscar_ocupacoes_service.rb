# frozen_string_literal: true

class Ocupacao
  class BuscarOcupacoesService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      @relation = ::Ocupacao.all
      filter_by_params
      paginate
      order

      Success.new(@relation)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar ocupações')
    end

    private

    attr_reader :params

    # rubocop:disable Metrics/AbcSize
    def filter_by_params
      return if params.empty?

      if params[:search_term].present?
        @relation = @relation.where(
          'codigo ILIKE ? OR nome ILIKE ?',
          "%#{params[:search_term]}%", "%#{params[:search_term]}%"
        )
      end

      @relation = @relation.where('nome ILIKE ?', "%#{params[:nome]}%") if params[:nome].present?
      @relation = @relation.where('codigo ILIKE ?', "%#{params[:codigo]}%") if params[:codigo].present?
      @relation = @relation.where(saude: params[:saude]) if params[:saude].present?

      @relation
    end
    # rubocop:enable Metrics/AbcSize

    def order
      direction = params[:order_direction] || 'asc'
      order = params[:order] || 'nome'

      @relation = @relation.send(:"order_by_#{order}", direction)
    end

    def paginate
      page = params[:page] || 1
      per = params[:per_page] || 10

      @relation = @relation.page(page).per(per)
    end
  end
end
