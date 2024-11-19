# frozen_string_literal: true

class UnidadeSaude
  module ImportacaoZip
    class EnvioCNESService < ApplicationService
      attr_reader :params

      FILE_VALIDATIONS = {
        content_types: %w[.zip application/zip application/x-zip application/x-zip-compressed],
        max_size: 10.megabytes
      }.freeze

      def initialize(params)
        @params = params
      end

      def call
        validate_file!(@params[:file])
        result = upload_file!

        Success.new(result)
      rescue StandardError => e
        Rails.logger.error(e)

        Failure.new('Não foi possivel enviar CNES')
      end

      private

      def validate_file!(file)
        if file.size > FILE_VALIDATIONS[:max_size]
          raise StandardError,
                "Tamanho do arquivo excede o limite de #{FILE_VALIDATIONS[:max_size]}. Envie arquivos menores."
        end

        return if FILE_VALIDATIONS[:content_types].include?(file.content_type)

        raise StandardError,
              "Tipo de arquivo inválido. Tipos permitidos: #{FILE_VALIDATIONS[:content_types].join(', ')}"
      end

      def upload_file!
        result = CNESApi::CNESRepository.importar_arquivo_zip(@params[:file])
        raise StandardError, result[:error] if result[:success] == false

        result
      end
    end
  end
end
