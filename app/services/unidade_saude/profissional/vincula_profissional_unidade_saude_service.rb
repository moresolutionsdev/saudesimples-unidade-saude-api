# frozen_string_literal: true

class UnidadeSaude
  module Profissional
    class VinculaProfissionalUnidadeSaudeService < ApplicationService
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        validar_requisitos!

        vinculo_profissional = ::ProfissionalUnidadeSaude.create(
          profissional_id: @params[:profissional_id],
          unidade_saude_id: @params[:unidade_saude_id],
          ocupacao_id: @params[:ocupacao_id]
        )

        Success.new(dados_de_resposta(vinculo_profissional))
      rescue StandardError => e
        Rails.logger.error(e.message)

        Failure.new('Não foi possivel vincular profissional com unidade de saúde')
      end

      private

      def validar_requisitos!
        ::UnidadeSaude::Profissional::VinculaProfissionalUnidadeSaudeValidadeService.call(@params)
      end

      def dados_de_resposta(vinculo_de_profissional)
        vinculo_id = vinculo_de_profissional.id
        ocupacao = vinculo_de_profissional.ocupacao
        profissional = vinculo_de_profissional.profissional

        {
          id: vinculo_id,
          ocupacao: {
            id: ocupacao.id,
            codigo: ocupacao.codigo,
            nome: ocupacao.nome
          },
          profissional: {
            id: profissional.id,
            matricula: profissional.matricula,
            codigo_cnes: profissional.codigo_cns,
            nome: profissional.nome,
            cpf_numero: profissional.cpf_numero
          }
        }.with_indifferent_access
      end
    end
  end
end
