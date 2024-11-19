# frozen_string_literal: true

module Agendas
  class CreateMapaPeriodoService < ApplicationService
    def initialize(agenda_id, params)
      @params = params
      @params[:agenda_id] = agenda_id
    end

    def call
      validate_flags
      validate_conflito_horarios
      Success.new(create_agenda_periodo)
    rescue ArgumentError => e
      Rails.logger.error(e.message)
      Failure.new({ error: e.message, status: 400 })
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new(e.message)
    end

    private

    # não são ambos verdadeiros. Caso um seja true, deve ajustar para compatibilidade.
    def validate_flags
      possui_horario_distribuido = string_para_boolean(@params[:possui_horario_distribuido] || '')
      possui_tempo_atendimento_configurado = string_para_boolean(@params[:possui_tempo_atendimento_configurado] || '')

      if possui_horario_distribuido && possui_tempo_atendimento_configurado
        raise 'campos "possui_horario_distribuido" e "possui_tempo_atendimento_configurado" não podem ambos ser true.'
      end

      # Compatibilidade: quando `possui_tempo_atendimento_configurado` for true
      @params[:possui_horario_distribuido] = true if possui_tempo_atendimento_configurado
    end

    # Valida conflitos de horários no mesmo dia dentro dos períodos
    def validate_conflito_horarios
      @params[:mapa_dias].each do |dia|
        check_conflito_horarios(dia[:mapa_horarios].sort_by { |h| h[:hora_inicio] })
      end
    end

    def check_conflito_horarios(intervalos)
      (0...intervalos.size - 1).each do |i|
        if Time.zone.parse(intervalos[i][:hora_fim]) >= Time.zone.parse(intervalos[i + 1][:hora_inicio])
          raise 'Conflito de horários dentro do mesmo dia encontrado no período.'
        end
      end
    end

    # Criação da agenda com validações e parâmetros ajustados
    def create_agenda_periodo
      AgendaMapaPeriodoRepository.create_with_associations(@params)
    end

    def string_para_boolean(str)
      str.to_s.downcase == 'true'
    end
  end
end
