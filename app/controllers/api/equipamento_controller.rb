# frozen_string_literal: true

module Api
  class EquipamentoController < ApplicationController
    # GET /equipamento
    def index
      result = Equipamentos::EquipamentoService.new.search_by_nome(search_params)

      render_200 serialize(result[:data], EquipamentoSerializer, view: :normal)
    end

    def search_params
      params.permit(:nome)
    end
  end
end
