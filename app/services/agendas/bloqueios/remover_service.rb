# frozen_string_literal: true

module Agendas
  module Bloqueios
    class RemoverService < ApplicationService
      def initialize(params)
        @agenda_id = params[:agenda_id]
        @bloqueio_id = params[:id]
        @replicar = params[:replicar] || false
      end

      def call
        bloqueio = ::AgendaBloqueioRepository.find_bloqueio(@agenda_id, @bloqueio_id)

        return Failure.new('Bloqueio não encontrado') unless bloqueio

        ActiveRecord::Base.transaction do
          bloqueio.destroy

          replicate_bloqueios(bloqueio) if @replicar
        end

        Success.new('')
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao remover bloqueio')
      end

      private

      def replicate_bloqueios(bloqueio)
        ::AgendaBloqueioRepository.find_bloqueios_to_replicate(bloqueio).destroy_all
      end
    end
  end
end
