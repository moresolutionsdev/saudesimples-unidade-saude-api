# frozen_string_literal: true

class UnidadeSaude
  module ImportacaoZip
    class SincronizarService < ApplicationService
      def call
        @result = SyncUnidadesDeSaudeWithCNESJob.perform_later(1)

        Success.new(@result)
      rescue StandardError => e
        Rails.logger.error(e)

        @error = 'Não foi possivel sincronizar com CNES'
        Failure.new(@error)
      end
    end
  end
end
