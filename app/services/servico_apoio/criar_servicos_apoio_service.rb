# frozen_string_literal: true

class ServicoApoio
  class CriarServicosApoioService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      return Success.new(@record) if create

      Rails.logger.error("[#{self.class}] Erro ao criar serviço de apoio #{@record.errors}")
      Failure.new(@record.errors.messages)
    end

    private

    attr_reader :params

    def create
      @record = ::ServicoApoioRepository.new(params)
      @record.save
    end
  end
end
