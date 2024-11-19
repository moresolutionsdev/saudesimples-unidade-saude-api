# frozen_string_literal: true

class UnidadeSaude
  module Importacao
    class CNESService < ApplicationService
      attr_reader :params

      BASE_URL = Rails.configuration.env_params.importacao_cnes_api_url
      IMPORT_API_URL = 'unidades_saude?cnes='
      PROFISSIONAIS_API_URL = 'profissionais/'

      def initialize(import_params)
        @params = import_params
        @response = nil
      end

      def call
        cnes = @params
        return Failure.new('CNES_EMPTY') if cnes.nil?
        return Failure.new('CNES_EMPTY') unless cnes.size.positive?

        cnes.each do |codigo|
          busca_unidade_saude_api(codigo)
          prepara_dados_unidade_saude
          cria_ou_atualiza_unidade_saude(codigo)
          atualiza_profissionais
        end

        Success.new(true)
      rescue StandardError => e
        Rails.logger.error(e)

        Failure.new(e)
      end

      private

      def busca_unidade_saude_api(codigo)
        @response = CNESApi::CNESRepository.busca_unidade_saude_por_cnes(codigo)

        raise StandardError, 'IMPORT_API_ERROR' unless @response[:success]

        @unidade_saude_data = @response[:data][:unidades_de_saude].first
      end

      def prepara_dados_unidade_saude
        @unidade_saude_params = {
          nome: @unidade_saude_data[:nome_fantasia],
          cnpj_numero: @unidade_saude_data[:cnpj],
          codigo_cnes: @unidade_saude_data[:cnes],
          classificacao_cnes_id:,
          descricao_subtipo_unidade_id:,
          telefone: @unidade_saude_data[:telefone1],
          fax: @unidade_saude_data[:fax],
          email: @unidade_saude_data[:email],
          **endereco_unidade_saude
        }
      end

      def cria_ou_atualiza_unidade_saude(codigo)
        unidade_saude = UnidadeSaudeRepository.search_by_cnes(codigo).first

        if unidade_saude.present?
          atualiza_unidade_saude(unidade_saude)
        else
          cria_unidade_saude
        end
      end

      def atualiza_unidade_saude(unidade_saude)
        unidade_saude_atualizada = unidade_saude
          .update(@unidade_saude_params)

        unless unidade_saude_atualizada
          raise UnidadeSaude::UnidadeSaudeAtualizarError, unidade_saude_atualizada.errors.full_messages
        end

        @unidade_saude_data[:id] = unidade_saude.id
      end

      def cria_unidade_saude
        @unidade_saude_data = @response[:data][:unidades_de_saude].first

        nova_unidade_saude = UnidadeSaudeRepository.new(@unidade_saude_params).create

        @unidade_saude_data[:id] = nova_unidade_saude.id
      end

      def classificacao_cnes_id
        classificacao_cnes = ClassificacaoUnidadeSaudeRepository
          .search_by_codigo(@unidade_saude_data[:tipo_unidade_saude]).first

        return classificacao_cnes.id if classificacao_cnes.present?

        ClassificacaoUnidadeSaudeRepository.create(
          { codigo: @unidade_saude_data[:tipo_unidade_saude],
            nome: @unidade_saude_data[:descricao_tipo_unidade_saude] }
        ).id
      end

      def descricao_subtipo_unidade_id
        return if @unidade_saude_data[:codigo_subtipo_unidade_saude].nil?

        descricao_subtipo_unidade = DescricaoSubtipoUnidade
          .where(classificacao_cnes_id: @unidade_saude_data[:tipo_unidade_saude]).first

        return descricao_subtipo_unidade.id if descricao_subtipo_unidade.present?

        DescricaoSubtipoUnidade.create(
          codigo: @unidade_saude_data[:codigo_subtipo_unidade_saude],
          nome: @unidade_saude_data[:descricao_subtipo_unidade],
          classificacao_cnes_id: @unidade_saude_data[:tipo_unidade_saude]
        ).id
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def endereco_unidade_saude
        endereco = @unidade_saude_data[:enderecos].first

        return {} if endereco.blank?

        result = {}

        result[:numero] = endereco[:numero]

        data = UnidadeSaudeEnderecoService.new.buscar_cep(endereco[:cep])[:data]

        busca_cep = data[:busca_cep]
        municipio = (MunicipioSerializer.render_as_hash(data[:municipio]) if data[:municipio].present?)
        result[:municipio_id] = municipio[:id]

        estado = (EstadoSerializer.render_as_hash(data[:estado]) if data[:estado].present?)
        result[:estado_id] = estado[:id]

        logradouro = (LogradouroSerializer.render_as_hash(data[:logradouro]) if data[:logradouro].present?)
        result[:tipo_logradouro_id] = logradouro[:tipo_logradouro_id] unless logradouro.nil?

        result[:logradouro] = busca_cep[:logradouro] || endereco[:logradouro]
        result[:cep] = busca_cep[:cep] if busca_cep[:cep]
        result[:bairro] = busca_cep[:bairro] if busca_cep[:bairro]
        result
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def atualiza_profissionais
        return if @unidade_saude_data[:lotacoes].empty?

        exclui_profissionais_desatualizados
        @unidade_saude_data[:lotacoes].each do |lotacao|
          atualiza_profissionais_lotacoes(lotacao)
        end
      end

      def atualiza_profissionais_lotacoes(lotacao)
        response = CNESApi::CNESRepository.busca_profissional_por_id(lotacao[:profissional_id])

        return unless response[:success]

        profissional = response[:data][:profissional]

        profissional_db = ProfissionalUnidadeSaudeRepository
          .by_cpf_profissional(@unidade_saude_data[:id], profissional[:cpf]).first

        atualiza_profissional(profissional_db, profissional[:codigo_cbo]) if profissional_db.present?
        inclui_profissional(profissional_db, profissional[:codigo_cbo]) if profissional_db.nil?
      rescue StandardError => e
        Failure.new(e)
      end

      def atualiza_profissional(profissional, codigo_cbo)
        if profissional.update(nome: profissional[:nome], codigo_cns: profissional[:codigo_cns],
                               data_nascimento: profissional[:data_nascimento])

          vincula_profissional_unidade_saude(profissional_db.id, codigo_cbo)
        end
      end

      def inclui_profissional(profissional, codigo_cbo)
        novo_profissional = Profissional.new(profissional)
        vincula_profissional_unidade_saude(novo_profissional.id, codigo_cbo) if novo_profissional.save!
      end

      def exclui_profissionais_desatualizados
        profissionais = ProfissionalUnidadeSaude.joins(:profissional).where(unidade_saude_id: @unidade_saude_data[:id])
        profissionais.each do |profissional|
          exists = @unidade_saude_data[:lotacoes].any? do |lotacao|
            lotacao[:profissional_id] = profissional.profissional_id
          end

          unless exists
            profissional.deleted_at = DateTime.now
            profissional.save
          end
        end
      end

      def vincula_profissional_unidade_saude(profissional_id, codigo_cbo)
        exists = ::ProfissionalUnidadeSaude.where(profissional_id:,
                                                  unidade_saude_id: @unidade_saude_data[:id])
        return if exists

        ocupacao = Ocupacao.where(codigo: codigo_cbo).first

        Failure.new('CBO_NOT_FOUND') if ocupacao.nil?

        ::ProfissionalUnidadeSaude.create(
          profissional_id:,
          unidade_saude_id: @unidade_saude_data[:id],
          ocupacao_id: ocupacao.id,
          importacao_cnes: true
        )
      end
    end
  end
end
