# frozen_string_literal: true

class UnidadeSaude
  module ServicoEspecializado
    class CreateServicoEspecializadoService < ApplicationService
      def initialize(unidade_saude, params)
        @unidade_saude = unidade_saude
        @params = params
      end

      def call
        validate_params!(@params)

        servico_especializado = ServicosUnidadeSaudeRepository.create!(
          @unidade_saude,
          @params[:codigo_classificacao],
          @params[:caracteristica_servico_id],
          @params[:codigo_cnes_terceiro],
          @params[:atende_ambulatorial_nao_sus] || false,
          @params[:atende_ambulatorial_sus] || false,
          @params[:atende_hospitalar_nao_sus] || false,
          @params[:atende_hospitalar_sus] || false,
          @params[:endereco_complementar_unidade_id],
          @params[:servico_id]
        )

        Success.new(servico_especializado)
      rescue StandardError => e
        Failure.new(e.message)
      end

      private

      def validate_params!(params)
        raise ArgumentError, 'codigo_classificacao é obrigatório' if params[:codigo_classificacao].blank?
        raise ArgumentError, 'caracteristica_servico_id é obrigatório' if params[:caracteristica_servico_id].blank?
      end
    end
  end
end
