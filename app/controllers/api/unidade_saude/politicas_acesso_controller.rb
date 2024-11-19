# frozen_string_literal: true

module Api
  module UnidadeSaude
    class PoliticasAcessoController < ApplicationController
      def index
        case PoliticasAcesso::ListPoliticasAcessoService.call(index_params)
        in success: politicas
          render_200(
            TermoUsoSerializer.render_as_hash(politicas, view: :with_actions),
            meta: {
              current_page: params[:page] || 1,
              total_pages: politicas.total_pages,
              total_count: politicas.total_count
            }
          )
        in failure: error
          render_422 error
        end
      end

      def show
        case PoliticasAcesso::FindPoliticaAcessoService.call(params[:id])
        in success: termo_uso
          render_200 serialize(termo_uso, ::TermoUsoSerializer)
        in failure: error
          render_422 error
        end
      end

      def create
        case PoliticasAcesso::CreatePoliticaAcessoService.call(create_params)
        in success: termo_uso
          render_200 TermoUsoSerializer.render_as_hash(termo_uso, view: :default)
        in failure: error
          render_422 error
        end
      end

      def ultima_versao
        case PoliticasAcesso::UltimaVersaoService.call
        in success: termo_uso
          render_200 serialize(termo_uso, ::TermoUsoSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def create_params
        payload = params.permit(:documento_arquivo)

        nome = payload[:documento_arquivo].original_filename
        documento_tipo = :politica_acesso

        payload.merge(
          titulo: nome,
          versao: (TermoUso.where(titulo: nome, documento_tipo:).last&.versao.to_i + 1),
          usuario_id: current_user.id,
          documento_tipo:
        )
      end

      def index_params
        params.permit(:nome_arquivo, :data_criacao, :email_usuario, :order, :order_direction, :page, :per_page)
      end
    end
  end
end
