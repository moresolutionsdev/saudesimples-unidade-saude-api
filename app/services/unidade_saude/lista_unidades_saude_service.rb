# frozen_string_literal: true

class UnidadeSaude
  class ListaUnidadesSaudeService < ApplicationService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      unidades_saude = ::UnidadeSaudeRepository.ativas(@params)

      unidades_saude = unidades_saude.order("#{params[:order] || 'nome'} #{params[:order_direction] || 'asc'}")

      Success.new(unidades_saude)
    rescue StandardError => e
      Failure.new(e)
    end
  end
end
