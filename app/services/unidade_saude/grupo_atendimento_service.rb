# frozen_string_literal: true

class UnidadeSaude
  class GrupoAtendimentoService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      grupos = GrupoAtendimentoRepository.filter(@params)

      Success.new(grupos)
    rescue StandardError => e
      Failure.new(e.message)
    end
  end
end
