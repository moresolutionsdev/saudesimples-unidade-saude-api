# frozen_string_literal: true

module Api
  class ServicosClassificacaoController < ApplicationController
    def index
      codigo_servico = params[:codigo_servico]

      case ::UnidadeSaude::BuscarServicosClassificacaoService.call(codigo_servico)
      in success: servicos
        render_200 serialize(servicos, ::ServicosClassificacaoSerializer)
      in failure: error
        render_422(error)
      end
    end
  end
end
