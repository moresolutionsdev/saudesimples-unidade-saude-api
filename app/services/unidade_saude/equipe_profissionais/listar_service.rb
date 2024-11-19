# frozen_string_literal: true

class UnidadeSaude
  module EquipeProfissionais
    class ListarService < ApplicationService
      def initialize(params, use_paginate: true)
        @params = params
        @use_paginate = use_paginate
      end

      def call
        equipe_profissionais = ::EquipeProfissionalRepository.search(@params)

        if @use_paginate
          Success.new(paginate(equipe_profissionais))
        else
          Success.new(equipe_profissionais)
        end
      rescue StandardError => e
        Rails.logger.error(e)
        Failure.new('Erro ao listar profissionais da equipe')
      end

      private

      def paginate(equipe_profissionais)
        equipe_profissionais.page(@params[:page] || 1).per(@params[:per_page] || 10)
      end
    end
  end
end
