# frozen_string_literal: true

class UnidadeSaude
  class AdicionaInstalacaoUnidadeSaudeService < ApplicationService
    def initialize(params)
      @params = params
      @instalacao_fisica_params = params.permit(:instalacao_fisica_id, :qtde_instalacoes, :qtde_leitos)
      @unidade_saude_id = params[:id]
    end

    def call
      unidade_saude = find_unidade_saude
      instalacao_fisica = find_instalacao_fisica
      instalacao_unidade_saude =
        create_instalacao_unidades_saude(
          unidade_saude.id,
          instalacao_fisica.id,
          instalacao_fisica_params[:qtde_instalacoes],
          instalacao_fisica_params[:qtde_leitos]
        )

      Success.new(instalacao_unidade_saude)
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new('Não foi possivel criar a Instalação de Unidade de Saude')
    end

    private

    attr_reader :params, :instalacao_fisica_params, :unidade_saude_id

    def find_unidade_saude
      ::UnidadeSaude.find(unidade_saude_id)
    end

    def find_instalacao_fisica
      ::InstalacaoFisica.find(instalacao_fisica_params[:instalacao_fisica_id])
    end

    def create_instalacao_unidades_saude(unidade_saude_id, instalacao_fisica_id, qtde_instalacoes, qtde_leitos)
      ::InstalacaoUnidadeSaudeRepository.create!(unidade_saude_id, instalacao_fisica_id, qtde_instalacoes, qtde_leitos)
    end
  end
end
