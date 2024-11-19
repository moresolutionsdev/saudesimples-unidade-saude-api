# frozen_string_literal: true

class UnidadeSaude
  module ServicosApoio
    class BuscaTiposService < ApplicationService
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        tipos_servicos = ::TipoServicoApoio.where('nome ilike ?', "%#{@params[:nome]}%")

        Success.new(tipos_servicos)
      rescue StandardError => e
        Rails.logger.info(e)
        { error: "Não foi possivel encontrar o tipo de serviço com o nome #{@service_type_name}" }
      end
    end
  end
end
