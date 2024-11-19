# frozen_string_literal: true

module Endereco
  module Paises
    class ListarService < ApplicationService
      def initialize(params)
        @page = params[:page] || 1
        @per_page = params[:per_page] || 25
        @search_term = params[:search_term]
      end

      def call
        paises = if @search_term.present?
                   paginate(PaisRepository.where('nome ILIKE ?', "#{@search_term}%").order(nome: :asc))
                 else
                   paginate(PaisRepository.order(nome: :asc))
                 end

        Success.new(paises)
      rescue StandardError => e
        Rails.logger.error(e)

        Failure.new('Erro ao listar paises')
      end

      private

      def paginate(resources)
        resources.page(@page).per(@per_page)
      end
    end
  end
end
