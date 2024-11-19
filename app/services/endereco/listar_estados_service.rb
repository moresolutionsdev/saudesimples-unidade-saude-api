# frozen_string_literal: true

module Endereco
  class ListarEstadosService < ApplicationService
    def call
      Success.new(EstadoRepository.all)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao listar os estados')
    end
  end
end
