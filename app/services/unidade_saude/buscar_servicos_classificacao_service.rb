# frozen_string_literal: true

class UnidadeSaude
  class BuscarServicosClassificacaoService < ApplicationService
    def initialize(codigo_servico)
      @codigo_servico = codigo_servico
    end

    def call
      servicos = if @codigo_servico.present?
                   ::ServicoClassificacaoRepository.find_by_codigo_servico(@codigo_servico) # rubocop:disable Rails/DynamicFindBy
                 else
                   ::ServicoClassificacaoRepository.all
                 end

      Success.new(servicos)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Não foi possivel encontrar o servico')
    end
  end
end
