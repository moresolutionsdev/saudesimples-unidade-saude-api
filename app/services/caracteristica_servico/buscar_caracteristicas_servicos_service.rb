# frozen_string_literal: true

class CaracteristicaServico
  class BuscarCaracteristicasServicosService < ApplicationService
    def call
      Success.new(::CaracteristicaServico.all)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar características de serviços')
    end
  end
end
