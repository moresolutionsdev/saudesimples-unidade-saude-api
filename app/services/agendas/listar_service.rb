# frozen_string_literal: true

module Agendas
  class ListarService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      Success.new(resultado)
    rescue StandardError => e
      Rails.logger.error(e.message)
      Failure.new('Falha ao listar agendas')
    end

    private

    attr_reader :params

    # rubocop:disable Metrics/AbcSize
    def resultado
      agendas = repository.joins(:agenda_mapa_periodos, :unidade_saude_ocupacao)
        .distinct

      agendas = filtrar_por_unidade_saude(agendas)
      agendas = filtrar_por_data_inicial(agendas)
      agendas = filtrar_por_data_final(agendas)
      agendas = filtrar_por_padrao_agenda(agendas)
      agendas = filtrar_por_profissional(agendas)
      agendas = filtrar_por_ocupacao(agendas)
      agendas = filtrar_por_procedimento(agendas)
      agendas = filtrar_por_tipo_agenda(agendas)
      agendas = filtrar_por_inativo(agendas)

      agendas = order_by(agendas, params[:order], params[:order_direction])
      agendas.page(params[:page]).per(params[:per_page])
    end
    # rubocop:enable Metrics/AbcSize

    def filtrar_por_unidade_saude(agendas)
      return agendas if params[:unidade_saude_id].blank?

      agendas.where(unidades_saude_ocupacoes: { unidade_saude_id: params[:unidade_saude_id] })
    end

    def filtrar_por_data_inicial(agendas)
      return agendas if params[:data_inicial].blank?

      agendas.where(agendas_mapas_periodos: { data_inicial: (params[:data_inicial]).. })
    end

    def filtrar_por_data_final(agendas)
      return agendas if params[:data_final].blank?

      agendas.where(agendas_mapas_periodos: { data_final: ..(params[:data_final]) })
    end

    def filtrar_por_padrao_agenda(agendas)
      return agendas if params[:padrao_agenda_id].blank?

      agendas.where(padrao_agenda_id: params[:padrao_agenda_id])
    end

    def filtrar_por_profissional(agendas)
      return agendas if params[:profissional_id].blank?

      agendas.where(profissional_id: params[:profissional_id])
    end

    def filtrar_por_ocupacao(agendas)
      return agendas if params[:ocupacao_id].blank?

      agendas.where(unidades_saude_ocupacoes: { ocupacao_id: params[:ocupacao_id] })
    end

    def filtrar_por_procedimento(agendas)
      return agendas if params[:procedimento_id].blank?

      agendas.where(procedimento_id: params[:procedimento_id])
    end

    def filtrar_por_tipo_agenda(agendas)
      return agendas if params[:regulacao].blank? && params[:local].blank?

      agendas = filtrar_por_regulacao(agendas)
      filtrar_por_local(agendas)
    end

    def filtrar_por_inativo(agendas)
      status = params[:inativo]

      return agendas if status.nil?

      agendas.where(inativo: status)
    end

    def filtrar_por_regulacao(agendas)
      return agendas if params[:regulacao].blank?

      agendas.where(regulacao: true)
    end

    def filtrar_por_local(agendas)
      return agendas if params[:local].blank?

      agendas.where(local: true)
    end

    def order_by(agendas, column, order_direction)
      return agendas if column.nil? || allowed_order_fields.exclude?(column)

      if column == 'profissional.nome'
        agendas.includes(:profissional).order("profissionais.nome #{order_direction}")
      else
        agendas.order("#{column} #{order_direction}")
      end
    end

    def repository
      ::Agenda
    end

    def allowed_order_fields
      ['inativo', 'profissional.nome']
    end
  end
end
