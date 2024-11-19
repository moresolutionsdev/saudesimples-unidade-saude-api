# frozen_string_literal: true

class AtendimentoRepository < ApplicationRepository
  def self.upsert_unidade_saude(nome:, endereco:, telefone:, latitude:, longitude:, horarios:) # rubocop:disable Metrics/ParameterLists
    unidade_saude = ::UnidadeSaude.find_or_initialize_by(nome:)
    unidade_saude.update(
      endereco:,
      telefone:,
      latitude:,
      longitude:
    )

    raise ActiveRecord::RecordInvalid, unidade_saude unless unidade_saude.valid?

    horarios.each do |horario|
      dia_atendimento = find_dia_atendimento_by_nome(horario[:dia_semana])
      upsert_dia_atendimento(
        unidade_saude.id,
        dia_atendimento_id: dia_atendimento.id,
        horario_inicio: horario[:horario_inicio],
        horario_encerramento: horario[:horario_encerramento]
      )
    end

    unidade_saude
  end

  def self.upsert_dia_atendimento(unidade_saude_id, dia_atendimento_id:, horario_inicio:, horario_encerramento:)
    horario = ::UnidadeSaudeHorario.find_or_initialize_by(
      unidade_saude_id:,
      dia_atendimento_id:
    )

    horario_inicio_time = Time.zone.parse(horario_inicio)
    horario_encerramento_time = Time.zone.parse(horario_encerramento)
    horario.update(
      hora_inicio: horario_inicio_time,
      hora_fim: horario_encerramento_time
    )

    raise ActiveRecord::RecordInvalid, horario unless horario.valid?

    horario
  end

  def self.find_dia_atendimento_by_nome(dia_semana)
    dia_semana_formatted = dia_semana.upcase.gsub(/[^A-Z0-9\s-]/, '')
    ::DiaAtendimento.where("REGEXP_REPLACE(UPPER(nome), '[^A-Z0-9\\s-]', '', 'g') = ?",
                           dia_semana_formatted).first
  end
end
