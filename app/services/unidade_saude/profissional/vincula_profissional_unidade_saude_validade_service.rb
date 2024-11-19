# frozen_string_literal: true

class UnidadeSaude
  module Profissional
    class VinculaProfissionalUnidadeSaudeValidadeService < ApplicationService
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        unless tem_permissao_para_vincular_profissional?
          raise ::UnidadeSaude::Profissional::VinculoProfissionalError,
                'Nâo tem permissão para vincular profissional com a unidade de saúde'
        end

        unless existe_unidade_saude?
          raise ::UnidadeSaude::Profissional::VinculoProfissionalError,
                "Nâo foi possivel encontrar a unidade de saúde com id #{params[:id]}"
        end

        unless existe_profissional?
          raise ::UnidadeSaude::Profissional::VinculoProfissionalError,
                "Nâo foi possivel encontrar a profissional com id #{params[:profissional_id]}"
        end

        raise ::UnidadeSaude::Profissional::VinculoProfissionalError, 'Profissional já vinculado' if vinculo_existente?

        return if existe_ocupacao?

        raise ::UnidadeSaude::Profissional::VinculoProfissionalError,
              "Nâo foi possivel encontrar a ocupação com id #{params[:ocupacao_id]}"
      end

      private

      def tem_permissao_para_vincular_profissional?
        permissions = ::AuthorizationService.new(@params[:user],
                                                 ::UnidadeSaude.find(@params[:unidade_saude_id])).permissions
        permissions[:vinculo_de_profissional][:create]
      end

      def existe_unidade_saude?
        unidade_saude = ::UnidadeSaude.find(@params[:unidade_saude_id])

        return false if unidade_saude.nil?

        true
      end

      def existe_profissional?
        profissional = ::Profissional.find(params[:profissional_id])

        return false if profissional.nil?

        true
      end

      def existe_ocupacao?
        ocupacao = ::Ocupacao.find(params[:ocupacao_id])

        return false if ocupacao.nil?

        true
      end

      def vinculo_existente?
        profissional = ::ProfissionalUnidadeSaude.where(
          'profissional_id=? AND unidade_saude_id=?', @params[:profissional_id], @params[:unidade_saude_id]
        )

        return false if profissional.empty?

        true
      end
    end
  end
end
