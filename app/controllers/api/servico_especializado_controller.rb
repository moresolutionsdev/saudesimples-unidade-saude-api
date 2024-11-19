# frozen_string_literal: true

module Api
  class ServicoEspecializadoController < ApplicationController
    before_action :authorize_action!, only: %i[create destroy]

    def create
      case ::UnidadeSaude::ServicoEspecializado::CreateServicoEspecializadoService.call(
        unidade_saude, create_params
      )
      in success: servico_especializado
        render_200 serialize(servico_especializado, ::ServicoUnidadeSaudeSerializer)
      in failure: error
        render_422(error)
      end
    end

    def destroy
      case ::UnidadeSaude::ServicoEspecializado::DeletarServicoEspecializadoService.call(params[:id])
      in success: _
        render_204
      in failure: error
        render_422 error
      end
    end

    private

    def create_params
      params.require(:servico_especializado).permit(
        :codigo_classificacao,
        :caracteristica_servico_id,
        :codigo_cnes_terceiro,
        :atende_ambulatorial_nao_sus,
        :atende_ambulatorial_sus,
        :atende_hospitalar_nao_sus,
        :atende_hospitalar_sus,
        :endereco_complementar_unidade_id,
        :servico_id
      )
    end
  end
end
