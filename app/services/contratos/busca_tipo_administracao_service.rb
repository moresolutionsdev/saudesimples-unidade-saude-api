# frozen_string_literal: true

module Contratos
  class BuscaTipoAdministracaoService < ApplicationService
    def call
      Success.new(::ContratoRepository.tipo_administracao)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Erro ao buscar tipos de administração')
    end
  end
end
