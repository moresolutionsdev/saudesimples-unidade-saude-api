# frozen_string_literal: true

module Agendas
  class CreateAgendaService < ApplicationService
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/AbcSize
    def call
      validate_unidade_saude_ocupacao
      validate_profissional
      validate_flags
      validate_grupo_atendimento(@params)
      validate_equipamento_utilizavel
      validate_procedimento_id
      validate_conflito_datas
      validate_conflito_horarios
      create_agenda
      Success.new(@agenda)
    rescue ArgumentError => e
      Rails.logger.error(e.message)
      Failure.new({ error: e.message, status: 400 })
    rescue StandardError => e
      Rails.logger.error(e)

      Failure.new(e.message)
    end
    # rubocop:enable Metrics/AbcSize

    private

    # Valida se a unidade_saude_ocupacao_id foi enviada e existe
    def validate_unidade_saude_ocupacao
      return if AgendaRepository.unidade_saude_ocupacao_exists?(@params[:unidade_saude_ocupacao_id])

      raise 'Especialidade inválida'
    end

    # Valida se o profissional_id existe na tabela de profissionais
    def validate_profissional
      raise 'Profissional inválido' unless AgendaRepository.profissional_exists?(@params[:profissional_id])
    end

    # Valida se os dois flags `possui_horario_distribuido` e `possui_tempo_atendimento_configurado`
    # não são ambos verdadeiros. Caso um seja true, deve ajustar para compatibilidade.
    def validate_flags
      if @params[:mapa_periodos].any? do |periodo|
           periodo[:possui_horario_distribuido] && periodo[:possui_tempo_atendimento_configurado]
         end
        raise 'campos "possui_horario_distribuido" e "possui_tempo_atendimento_configurado" não podem ambos ser true.'
      end

      # Compatibilidade: quando `possui_tempo_atendimento_configurado` for true
      @params[:mapa_periodos].each do |periodo|
        periodo[:possui_horario_distribuido] = true if periodo[:possui_tempo_atendimento_configurado]
      end
    end

    def validate_grupo_atendimento(params)
      params[:mapa_periodos].each do |periodo|
        next if periodo[:mapa_dias].blank?

        periodo[:mapa_dias].each do |dia|
          next if dia[:mapa_horarios].blank?

          dia[:mapa_horarios].each do |horario|
            check_grupo_presence(horario[:grupo_atendimento_id])
          end
        end
      end
    end

    # Valida se equipamento_utilizavel_id é fornecido quando `possui_equipamento` é true
    def validate_equipamento_utilizavel
      return unless @params[:possui_equipamento] && @params[:equipamento_utilizavel_id].nil?

      raise "Equipamento utilizável é obrigatório quando 'possui_equipamento' é true."
    end

    # Valida se procedimento_id existe na tabela de procedimentos, caso seja enviado
    def validate_procedimento_id
      return if AgendaRepository.procedimento_exists?(@params[:procedimento_id])

      raise 'Procedimento inválido'
    end

    def validate_conflito_datas
      datas = @params[:mapa_periodos].map { |p| [p[:data_inicial], p[:data_final]] }
      # Ordena as datas pela data inicial
      datas.sort_by!(&:first)

      datas.each_cons(2) do |(_inicio1, fim1), (inicio2, _fim2)|
        raise 'Conflito de datas encontrado entre períodos.' if inicio2 <= fim1
      end
    end

    # Valida conflitos de horários no mesmo dia dentro dos períodos
    def validate_conflito_horarios
      @params[:mapa_periodos].each do |periodo|
        # compare hora_inicio e hora_fim de cada horário, se houver conflito, raise error
        periodo[:mapa_dias].each do |dia|
          check_conflito_horarios(dia[:mapa_horarios].sort_by { |h| h[:hora_inicio] })
        end
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
    def create_agenda
      @agenda = AgendaRepository.create_with_associations(@params)
    end

    def check_grupo_presence(grupo_atendimento_id)
      return if AgendaRepository.grupo_atendimento_exists?(grupo_atendimento_id)

      raise 'Grupo de atendimento não existe.'
    end
  end
end
