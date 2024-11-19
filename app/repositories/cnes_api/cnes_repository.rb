# frozen_string_literal: true

module CNESApi
  class CNESRepository < ApplicationRepository
    BASE_URL = Rails.configuration.env_params.importacao_cnes_api_url

    class << self
      def importar_arquivo_zip(file)
        url = "#{BASE_URL}/api/v1/cnes_files"
        payload = {
          'cnes_file[file]': Faraday::UploadIO.new(file.path, 'application/zip')
        }

        # Usando uma nova connection pois a connection da lib HttpClient não possui suporte a multipart
        conn = Faraday.new(url:) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded

          timeout = 360
          faraday.options.timeout = timeout
          faraday.options.open_timeout = timeout
        end

        parse_json(conn.post(url, payload))
      end

      def busca_unidade_saude(id:)
        url = "#{BASE_URL}/api/v1/unidades_saude/#{id}"

        parse_json(get(url:))
      end

      def busca_unidade_saude_por_cnes(codigo)
        url = "#{BASE_URL}/api/v1/unidades_saude?cnes=#{codigo}"

        parse_json(get(url:))
      end

      def busca_profissional_por_id(id)
        url = "#{BASE_URL}/api/v1/profissionais/#{id}"

        parse_json(get(url:))
      end

      def lista_unidade_saude(params = {})
        url = "#{BASE_URL}/api/v1/unidades_saude"
        payload = params.slice(:page, :per_page, :nome_fantasia, :cnpj, :cnes)

        parse_json(get(url:, payload:))
      end
    end
  end
end
