# frozen_string_literal: true

class UnidadeSaude
  module Equipes
    class DetalharService < ApplicationService
      def initialize(params)
        @unidade_saude_id = params[:unidade_saude_id]
        @id = params[:id]
      end

      def call
        equipe = UnidadeSaude::EquipeRepository.find_equipe_by_unidade(@unidade_saude_id, @id)

        if equipe.present?
          Success.new(equipe)
        else
          Failure.new('Equipe não encontrada')
        end
      end

      private

      attr_reader :unidade_saude_id, :id
    end
  end
end
