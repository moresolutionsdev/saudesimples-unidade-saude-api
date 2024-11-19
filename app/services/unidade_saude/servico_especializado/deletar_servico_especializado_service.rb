# frozen_string_literal: true

class UnidadeSaude
  module ServicoEspecializado
    class DeletarServicoEspecializadoService < ApplicationService
      def initialize(id)
        @id = id
      end

      def call
        destroy

        Success.new(true)
      rescue ActiveRecord::ActiveRecordError => e
        Rails.logger.error(e)

        Failure.new('Erro ao remover o serviço especializado da unidade de saude')
      end

      private

      def destroy
        ::ServicoUnidadeSaude.find(@id).destroy!
      end
    end
  end
end
