# frozen_string_literal: true

module Api
  module UnidadeSaude
    module InstalacaoFisica
      class InstalacaoUnidadesController < ApplicationController
        before_action :authorize_action!, only: %i[destroy]
        def index
          case ::UnidadeSaude::ListaInstalacoesUnidadeSaudeService.call(params)
          in success: instalacoes
            render_200(
              serialize(instalacoes, ::InstalacaoUnidadeSaudeSerializer, view: :extended),
              meta: {
                current_page: params[:page] || 1,
                total_pages: instalacoes.total_pages,
                total_count: instalacoes.total_count
              }
            )
          in failure: error_message
            render_422 error_message
          end
        end

        def create
          case ::UnidadeSaude::AdicionaInstalacaoUnidadeSaudeService.call(params)
          in success: instalacao
            render_201 serialize(instalacao, ::InstalacaoUnidadeSaudeSerializer, view: :normal)
          in failure: error_message
            render_422 error_message
          end
        end

        def destroy
          case ::UnidadeSaude::DeletaInstalacaoUnidadeSaudeService.call(params[:id])
          in success: _
            render_204
          in failure: error
            render_422 error
          end
        end
      end
    end
  end
end
