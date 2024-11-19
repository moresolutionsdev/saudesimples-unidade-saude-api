# frozen_string_literal: true

class AgendaRepository < ApplicationRepository
  class << self
    delegate_missing_to Agenda

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def create_with_associations(params)
      # Criação de agenda com associações
      ActiveRecord::Base.transaction do
        # Cria a agenda
        agenda = Agenda.create!(
          unidade_saude_ocupacao_id: params[:unidade_saude_ocupacao_id],
          profissional_id: params[:profissional_id],
          procedimento_id: params[:procedimento_id],
          possui_equipamento: params[:possui_equipamento],
          equipamento_utilizavel_id: params[:equipamento_utilizavel_id],
          local: params[:local],
          regulacao: params[:regulacao],
          sexo_id: params[:sexo_id],
          tipo_atendimento_agenda_id: params[:tipo_atendimento_agenda_id],
          padrao_agenda_id: params[:padrao_agenda_id],
          grupo_atendimento_id: params[:grupo_atendimento_id]
        )

        # Cria os períodos relacionados à agenda
        params[:mapa_periodos].each do |periodo|
          agenda_map_periodo = agenda.agenda_mapa_periodos.create!(
            data_inicial: periodo[:data_inicial],
            data_final: periodo[:data_final],
            possui_horario_distribuido: periodo[:possui_horario_distribuido] || false,
            possui_tempo_atendimento_configurado: periodo[:possui_tempo_atendimento_configurado] || false,
            inativo: periodo[:inativo] || false,
            dias_agendamento: periodo[:dias_agendamento],
            data_liberacao_agendamento: periodo[:data_liberacao_agendamento]
          )

          # Cria os tempos de atendimento relacionados ao período
          agenda_map_periodo.agenda_mapa_periodo_tempo_atendimentos.create!(
            nova_consulta: periodo.dig(:tempo_atendimento, :nova_consulta) || 60,
            retorno: periodo.dig(:tempo_atendimento, :retorno) || 60,
            reserva_tecnica: periodo.dig(:tempo_atendimento, :reserva_tecnica) || 60,
            regulacao: periodo.dig(:tempo_atendimento, :regulacao) || 60,
            regulacao_retorno: periodo.dig(:tempo_atendimento, :regulacao_retorno) || 60
          )

          # Cria os dias e horários relacionados ao período
          periodo[:mapa_dias].each do |dia|
            agenda_mapa_dia = AgendaMapaDia.create!(
              dia_atendimento_id: dia[:dia_atendimento_id],
              agenda_mapa_periodo_id: agenda_map_periodo.id
            )

            dia[:mapa_horarios].each do |horario|
              AgendaMapaHorario.create!(
                agenda_mapa_dia_id: agenda_mapa_dia.id,
                hora_inicio: horario[:hora_inicio],
                hora_fim: horario[:hora_fim],
                retorno: horario[:retorno],
                nova_consulta: horario[:nova_consulta],
                reserva_tecnica: horario[:reserva_tecnica],
                regulacao: horario[:regulacao] || 0,
                regulacao_retorno: horario[:regulacao_retorno] || 0,
                hora_inicio_str: horario[:hora_inicio_str],
                hora_fim_str: horario[:hora_fim_str],
                observacao: horario[:observacao],
                grupo_atendimento_id: horario[:grupo_atendimento_id]
              )
            end
          end
        end
        agenda
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # Verifica a existência de uma unidade_saude_ocupacao pelo ID
    def unidade_saude_ocupacao_exists?(id)
      UnidadeSaudeOcupacao.exists?(id)
    end

    # Verifica a existência de um profissional pelo ID
    def profissional_exists?(id)
      Profissional.exists?(id)
    end

    # Verifica a existência de uma ocupação pelo ID
    def procedimento_exists?(id)
      Procedimento.exists?(id)
    end

    def historico_agendamentos?(agenda_id, agendamento_ids)
      return true if any_related_records_exists?(agenda_id, agendamento_ids)

      false
    end

    def exist?(agenda_id)
      Agenda.exists?(agenda_id)
    end

    def delete_agenda(agenda_id)
      logical_delete_agenda(agenda_id)
    end

    private

    def any_related_records_exists?(agenda_id, agendamento_ids)
      agendamentos_exists?(agenda_id) ||
        ambulatorial_atendimentos_exists?(agenda_id) ||
        esus_related_records_exists?(agendamento_ids)
    end

    def esus_related_records_exists?(agendamento_ids)
      esus_fichas_atendimento_domiciliar_exists?(agendamento_ids) ||
        esus_fichas_atendimento_odontologico_exists?(agendamento_ids) ||
        esus_fichas_atividades_coletivas_exists?(agendamento_ids) ||
        esus_fichas_avaliacoes_elegibilidades_exists?(agendamento_ids) ||
        esus_fichas_procedimentos_exists?(agendamento_ids) ||
        esus_fichas_visitas_domiciliares_exists?(agendamento_ids)
    end

    def agendamentos_exists?(agenda_id)
      Agendamento.exists?(agenda_id:)
    end

    def ambulatorial_atendimentos_exists?(agenda_id)
      AmbulatorialAtendimento.joins(:agendamento).exists?(agendamentos: { agenda_id: })
    end

    def esus_fichas_atendimento_domiciliar_exists?(agendamento_ids)
      Esus::FichaAtendimentoDomiciliar.joins(:agendamento).exists?(agendamentos_id: agendamento_ids,
                                                                   atendivel_type: 'Agendamento')
    end

    def esus_fichas_atendimento_odontologico_exists?(agendamento_ids)
      Esus::FichaAtendimentoOdontologico.exists?(atendivel_type: 'Agendamento', atendivel_id: agendamento_ids)
    end

    def esus_fichas_atividades_coletivas_exists?(agendamento_ids)
      Esus::FichaAtividadeColetiva.exists?(atendivel_type: 'Agendamento', atendivel_id: agendamento_ids)
    end

    def esus_fichas_avaliacoes_elegibilidades_exists?(agendamento_ids)
      Esus::FichaAvaliacaoElegibilidade.exists?(atendivel_type: 'Agendamento', atendivel_id: agendamento_ids)
    end

    def esus_fichas_procedimentos_exists?(agendamento_ids)
      Esus::FichaProcedimento.exists?(atendivel_type: 'Agendamento', atendivel_id: agendamento_ids)
    end

    def esus_fichas_visitas_domiciliares_exists?(agendamento_ids)
      Esus::FichaVisitaDomiciliar.exists?(atendivel_type: 'Agendamento', atendivel_id: agendamento_ids)
    end

    def logical_delete_agenda(agenda_id)
      ActiveRecord::Base.transaction do
        Agenda.find(agenda_id).update(inativo: true)
        agenda = Agenda.find(agenda_id).destroy

        # Atualizando todas as agendas_mapas_periodos relacionadas
        # rubocop:disable Rails/SkipsModelValidations
        agenda.agenda_mapa_periodos.update_all(inativo: true)
        # rubocop:enable Rails/SkipsModelValidations
      end
      true
    rescue StandardError => e
      Rails.logger.error(e.message)
      false
    end
  end
end
