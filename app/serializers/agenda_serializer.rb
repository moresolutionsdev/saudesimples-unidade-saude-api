# frozen_string_literal: true

class AgendaSerializer < ApplicationSerializer
  identifier :id

  view :normal do
    fields :regulacao, :local, :inativo

    field :data_inicial do |object|
      object.agenda_mapa_periodos
        .order(:data_inicial)
        .first
        &.data_inicial
        &.strftime('%Y-%m-%d')
    end

    field :data_final do |object|
      object.agenda_mapa_periodos
        .order(:data_final)
        .first
        &.data_final
        &.strftime('%Y-%m-%d')
    end

    field :padrao_agenda do |object|
      object&.padrao_agenda&.nome
    end

    field :unidade_saude do |object|
      object.unidade_saude_ocupacao&.unidade_saude&.nome
    end

    field :acoes do |_|
      {
        editar: true,
        excluir: true,
        bloquear: true
      }
    end

    field :situacao do |object|
      object.inativo? ? 'Inativo' : 'Ativo'
    end

    field :especialidade do |object|
      {
        id: object.unidade_saude_ocupacao_id,
        nome: object.unidade_saude_ocupacao&.ocupacao&.nome
      }
    end

    association :profissional, blueprint: ProfissionalSerializer
    association :procedimento, blueprint: ProcedimentoSerializer
  end

  view :edicao_agenda do
    fields :id, :unidade_saude_ocupacao_id, :profissional_id, :procedimento_id,
           :grupo_atendimento_id, :possui_equipamento, :equipamento_utilizavel_id, :local, :regulacao
  end

  view :cadastro_agenda do
    include_view :normal

    fields :id, :unidade_saude_ocupacao_id, :profissional_id, :procedimento_id,
           :grupo_atendimento_id, :possui_equipamento, :equipamento_utilizavel_id, :local, :regulacao

    association :agenda_mapa_periodos, blueprint: AgendaMapaPeriodoSerializer
  end

  view :listagem_agenda do
    fields :regulacao, :local, :possui_equipamento

    association :unidade_saude_ocupacao, blueprint: UnidadeSaudeOcupacaoSerializer, view: :listagem_agenda
    association :padrao_agenda, blueprint: PadraoAgendaSerializer
    association :procedimento, blueprint: ProcedimentoSerializer, view: :listagem_agenda
    association :equipamento_utilizavel, blueprint: EquipamentoUtilizavelSerializer, view: :listagem_agenda
    association :profissional, blueprint: ProfissionalSerializer, view: :listagem_agenda
  end
end
