# frozen_string_literal: true

module Api
  class EquipesController < ApplicationController
    def show
      case Equipes::DetalharService.call(show_params)
      in success: equipe
        render_200(serialize(equipe, ::EquipeSerializer))
      in failure: error
        render_422(error)
      end
    end

    def create
      case ::Equipes::CriarService.call(create_params)
      in success: equipe
        render_201 serialize(equipe, ::EquipeSerializer)
      in failure: error
        render_422 error
      end
    end

    def update
      case ::Equipes::AtualizarService.call(update_params)
      in success: equipe
        render_200 serialize(equipe, ::EquipeSerializer)
      in failure: error
        render_422 error
      end
    end

    def alternar_situacao
      case ::Equipes::AlternarSituacaoService.call(params[:id])
      in success: equipe
        render_200 serialize(equipe, ::EquipeSerializer)
      in failure: error
        render_422 error
      end
    end

    def destroy
      case ::Equipes::ExcluirService.call(equipe_id: params[:id], user: current_user)
      in success: _
        render_204
      in failure: error
        render_422 error
      end
    end

    def exists
      case ::Equipes::FindByService.call(exists_params)
      in success: equipe
        render_200 serialize(equipe, ::EquipeSerializer)
      in failure: error
        render_422 error
      end
    end

    private

    def create_params
      params.require(:equipe).permit(
        :codigo,
        :nome,
        :area,
        :unidade_saude_id,
        :tipo_equipe_id,
        :data_ativacao,
        :data_desativacao,
        :motivo_desativacao,
        :populacao_assistida,
        :mapeamento_indigena_id,
        equipes_profissionais_attributes: %i[
          id
          equipe_id
          profissional_id
          ocupacao_id
          codigo_micro_area
          entrada
          data_saida
          _destroy
        ]
      )
    end

    def show_params
      params.require(:id)
      params.permit(:id)
    end

    def update_params
      create_params.merge(id: params[:id])
    end

    def exists_params
      params.require(:codigo)
      params.permit(:codigo)
    end
  end
end
