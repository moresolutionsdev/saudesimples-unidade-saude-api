# frozen_string_literal: true

class Profissional
  class BuscarProfissionaisService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      @relation = ::Profissional.all
      filter_by_name
      paginate
      order

      Success.new(@relation)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar profissionais')
    end

    private

    attr_reader :params

    def filter_by_name
      return if params[:nome].blank?

      @relation = @relation.where('nome ILIKE ?', "%#{params[:nome]}%")
    end

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
