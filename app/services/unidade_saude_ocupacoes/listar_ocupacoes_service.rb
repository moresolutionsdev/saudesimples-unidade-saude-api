# frozen_string_literal: true

module UnidadeSaudeOcupacoes
  class ListarOcupacoesService < ApplicationService
    def initialize(unidade_saude_id:, params:)
      @unidade_saude_id = unidade_saude_id
      @params = params
    end

    def call
      @ocupacoes = UnidadeSaudeOcupacaoRepository.joins(:ocupacao).where(unidade_saude_id: @unidade_saude_id)
      @ocupacoes = filtrar_por_profissional(@params[:profissional_id])
      @ocupacoes = filtrar_por_termo(@params[:term])

      Success.new(
        @ocupacoes.group(
          :id, :unidade_saude_id, :ocupacao_id, :bloqueado, :created_at, :updated_at,
          :atendimento_por_idade, :idade_inicial, :idade_final
        )
      )
    rescue StandardError => e
      Rails.logger.error(e.message)

      Failure.new('Erro ao listar ocupacoes')
    end

    private

    def filtrar_por_profissional(profissional_id)
      return @ocupacoes if profissional_id.nil?

      @ocupacoes
        .joins(
          'LEFT JOIN profissionais_unidades_saude ON ' \
          'profissionais_unidades_saude.ocupacao_id = unidades_saude_ocupacoes.ocupacao_id'
        )
        .where(profissionais_unidades_saude: { profissional_id: @params[:profissional_id] })
    end

    def filtrar_por_termo(termo)
      return @ocupacoes if termo.nil?

      @ocupacoes.where('ocupacoes.nome ILIKE ? OR ocupacoes.codigo ILIKE ?', "%#{termo}%", "%#{termo}%")
    end
  end
end
