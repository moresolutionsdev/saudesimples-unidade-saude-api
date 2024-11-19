# frozen_string_literal: true

class UnidadeSaude
  class BuscarServicosService < ApplicationService
    def call
      Success.new(ServicoRepository.all)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar serviços')
    end
  end
end
