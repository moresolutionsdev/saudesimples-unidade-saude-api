# frozen_string_literal: true

module Equipes
  class AlternarSituacaoService < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      @equipe = ::EquipeRepository.find(@id)

      if @equipe.data_desativacao.present?
        activate
      else
        deactivate
      end

      success(@equipe)
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end

    private

    def activate
      @equipe.update!(data_desativacao: nil, motivo_desativacao: nil, data_ativacao: Time.zone.now)
    end

    def deactivate
      @equipe.update!(data_desativacao: Time.zone.now, motivo_desativacao: 'reorganizacao')
    end
  end
end
