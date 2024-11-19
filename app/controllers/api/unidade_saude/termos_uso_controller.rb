# frozen_string_literal: true

module Api
  module UnidadeSaude
    class TermosUsoController < ApplicationController
      def index
        case TermosUso::ListTermosUsosService.call(index_params)
        in success: termos
          render_200(
            TermoUsoSerializer.render_as_hash(termos, view: :with_actions),
            meta: {
              current_page: params[:page] || 1,
              total_pages: termos.total_pages,
              total_count: termos.total_count
            }
          )
        in failure: error
          render_422 error
        end
      end

      def show
        case TermosUso::FindTermoUsoService.call(params[:id])
        in success: termo_uso
          render_200 serialize(termo_uso, ::TermoUsoSerializer)
        in failure: error
          render_422 error
        end
      end

      def create
        case TermosUso::CreateTermoUsoService.call(create_params)
        in success: termo_uso
          render_200 TermoUsoSerializer.render_as_hash(termo_uso, view: :default)
        in failure: error
          render_422(error)
        end
      end

      def ultima_versao
        case TermosUso::UltimaVersaoService.call
        in success: termo_uso
          render_200 serialize(termo_uso, ::TermoUsoSerializer)
        in failure: error
          render_422 error
        end
      end

      private

      def create_params
        params.permit(:documento_arquivo).tap do |payload|
          documento_arquivo = payload[:documento_arquivo]
          nome = documento_arquivo.original_filename
          documento_tipo = :termo_uso

          payload.merge!(
            titulo: nome,
            versao: (TermoUso.where(titulo: nome, documento_tipo:).last&.versao.to_i + 1),
            usuario_id: current_user.id,
            documento_tipo:,
            documento_arquivo:
          )
        end
      end

      def index_params
        params.permit(:nome_arquivo, :data_criacao, :email_usuario, :order, :order_direction, :page, :per_page)
      end
    end
  end
end
