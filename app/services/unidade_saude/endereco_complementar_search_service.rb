# frozen_string_literal: true

class UnidadeSaude
  class EnderecoComplementarSearchService < ApplicationService
    def initialize(unidade_saude:, search_term:)
      @unidade_saude = unidade_saude
      @search_term = search_term
    end

    def call
      return Success.new([]) if search_term.nil?

      enderecos = []

      enderecos << buscar_por_enderecos
      enderecos << buscar_por_municipio
      enderecos << buscar_por_estado

      Success.new(enderecos.flatten.uniq)
    rescue StandardError
      Failure.new('Erro ao encontrar endereços complementares')
    end

    private

    attr_reader :unidade_saude, :search_term

    def enderecos_complementares
      @enderecos_complementares ||= unidade_saude.enderecos_complementares
    end

    def buscar_por_enderecos
      enderecos_complementares.by_logradouro(search_term).or(enderecos_complementares.by_bairro(search_term))
    end

    def buscar_por_municipio
      municipio_id = Municipio.by_municipio(search_term).pluck(:id)

      enderecos_complementares.where(municipio_id:)
    end

    def buscar_por_estado
      estado_id = Estado.by_estado(search_term).pluck(:id)

      enderecos_complementares.where(estado_id:)
    end
  end
end
