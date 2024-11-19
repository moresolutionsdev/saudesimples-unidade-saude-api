# frozen_string_literal: true

module Agendas
  class AtualizaAgendaService < ApplicationService
    def initialize(id:, params:)
      @id = id
      @params = extract_agenda_params(params)
      @errors = []
    end

    def call
      return Failure.new('Agenda não encontrada') unless agenda_existente?

      validate_params

      # Se houver erros acumulados, retorna Failure com a lista de erros
      return Failure.new(@errors) unless @errors.empty?

      update_agenda
    rescue StandardError => e
      Rails.logger.error(e)
      Failure.new(e.message)
    end

    private

    # Verifica se os parâmetros estão dentro de `agenda`, se não, usa o formato direto
    def extract_agenda_params(params)
      params[:agenda] || params
    end

    # Valida todos os parâmetros e acumula erros
    def validate_params
      @errors << 'Especialidade inválida' if unidade_saude_ocupacao_invalida?
      @errors << 'Profissional inválido' if profissional_invalido?
      @errors << 'Padrão de Agenda inválido' if padrao_agenda_invalido?

      validate_equipment

      @errors << 'Procedimento inválido' if procedimento_invalido?
    end

    # Valida as condições de equipamento e acumula erros
    def validate_equipment
      if possui_equipamento_nao_informado_e_equipamento_informado?
        @errors << 'Não é possível especificar um equipamento utilizável se não informar se possui um equipamento'
      end

      if possui_equipamento_informado_e_equipamento_nao_informado?
        @errors << 'Obrigatório o envio de um equipamento utilizável, se possui um equipamento'
      end

      @errors << 'Equipamento utilizável inválido' if equipamento_invalido?
    end

    # Atualiza a agenda, retornando sucesso se não houver erros
    def update_agenda
      agenda = AgendaRepository.find(@id)
      agenda.update!(@params)
      Success.new(agenda)
    end

    def agenda_existente?
      Agenda.exists?(@id)
    end

    def unidade_saude_ocupacao_invalida?
      return false if @params[:unidade_saude_ocupacao_id].blank?

      !UnidadeSaudeOcupacao.exists?(@params[:unidade_saude_ocupacao_id])
    end

    def profissional_invalido?
      return false if @params[:profissional_id].blank?

      @params[:profissional_id].present? && !Profissional.exists?(@params[:profissional_id])
    end

    def possui_equipamento_nao_informado_e_equipamento_informado?
      @params[:possui_equipamento].blank? && @params[:equipamento_utilizavel_id].present?
    end

    def possui_equipamento_informado_e_equipamento_nao_informado?
      @params[:possui_equipamento].present? && @params[:equipamento_utilizavel_id].blank?
    end

    def equipamento_invalido?
      return false if possui_equipamento_nao_informado_e_equipamento_informado?
      return false if possui_equipamento_informado_e_equipamento_nao_informado?
      return false if @params[:equipamento_utilizavel_id].blank?

      !EquipamentoUtilizavel.exists?(@params[:equipamento_utilizavel_id])
    end

    def procedimento_invalido?
      return false if @params[:procedimento_id].blank?

      @params[:procedimento_id].present? && !Procedimento.exists?(@params[:procedimento_id])
    end

    def padrao_agenda_invalido?
      return false if @params[:padrao_agenda_id].blank?

      @params[:padrao_agenda_id].present? && !PadraoAgenda.exists?(@params[:padrao_agenda_id])
    end
  end
end
