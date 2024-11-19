# frozen_string_literal: true

module Agendas
  module OutrasInformacoes
    class ListarService < ApplicationService
      def initialize(params)
        @params = params
      end

      def call
        outras_informacoes = ::AgendaOutraInformacaoRepository.search(@params)

        Success.new(paginate(outras_informacoes))
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao listar outras informações da agenda')
      end

      private

      def paginate(outras_informacoes)
        outras_informacoes.page(@params[:page]).per(@params[:per_page])
      end
    end
  end
end
