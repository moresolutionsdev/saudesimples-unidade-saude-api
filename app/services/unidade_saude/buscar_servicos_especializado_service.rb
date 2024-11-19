# frozen_string_literal: true

class UnidadeSaude
  class BuscarServicosEspecializadoService < ApplicationService
    def initialize(unidade_saude, params)
      @unidade_saude_id = unidade_saude.id
      @params = params.merge(unidade_saude_id: @unidade_saude_id)
    end

    def call
      servicos = ::UnidadeSaudeServicoEspecializadoRepository.all(@params)

      Success.new(servicos)
    rescue StandardError => e
      Rails.logger.error e
      Failure.new('Não foi possivel encontrar o servico')
    end
  end
end
