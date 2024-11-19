# frozen_string_literal: true

class ServicoApoio
  class BuscarServicosApoioService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      @relation = ::ServicoApoio.includes(:unidade_saude, :tipo_servico_apoio, :caracteristica_servico).all
      filter_by_unidade_saude
      order
      paginate

      Success.new(@relation)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar serviços de apoio')
    end

    private

    attr_reader :params

    def filter_by_unidade_saude
      return if params[:unidade_saude_id].blank?

      @relation = @relation.where(unidade_saude_id: params[:unidade_saude_id])
    end

    def order
      direction = params[:order_direction] || 'asc'
      order = params[:order] || 'tipo_servico'

      @relation = @relation.send(:"order_by_#{order}", direction)
    end

    def paginate
      page = params[:page] || 1
      per = params[:per_page] || 10

      @relation = @relation.page(page).per(per)
    end
  end
end
