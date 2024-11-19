# frozen_string_literal: true

class ServicoApoio
  class DeletarServicosApoioService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      destroy

      Success.new(true)
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error(e)

      Failure.new('Erro ao remover o serviço de apoio')
    end

    private

    def destroy
      ::ServicoApoio.find(@id).destroy!
    end
  end
end
