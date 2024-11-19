# frozen_string_literal: true

class UnidadeSaudeSerializer < ApplicationSerializer
  identifier :id

  view :shared_fields_and_associations do
    association :unidades_saude_horarios, blueprint: HorarioFuncionamentoSerializer

    fields :cpf_numero, :cnpj_numero, :nome,
           :codigo_cnes, :status, :tipo_unidade,
           :classificacao_cnes_id, :descricao_subtipo_unidade_id,
           :cnpj_numero, :cpf_numero, :tipo_pessoa_cnes_id,
           :situacao_unidade_saude_id, :razao_social,
           :cep, :estado_id, :municipio_id, :tipo_logradouro_id,
           :logradouro, :numero, :bairro, :complemento,
           :telefone, :email, :url,
           :mantenedora, :municipio, :referencia_local

    field :actions do |unit, options|
      user = options[:current_user]
      authorization_service = AuthorizationService.new(user, unit)
      authorization_service.permissions
    end

    field :status do |unit, _options|
      unit.inativa ? 'Inativa' : 'Ativa'
    end
  end

  view :normal do
    include_view :shared_fields_and_associations
    fields :cpf_numero, :cnpj_numero, :nome, :codigo_cnes
    association :mantenedora, blueprint: MantenedoraSerializer, view: :normal
    association :municipio, blueprint: MunicipioSerializer, view: :normal
  end

  view :extended do
    include_view :shared_fields_and_associations
    fields :cpf_numero, :cnpj_numero, :nome, :codigo_cnes
    association :mantenedora, blueprint: MantenedoraSerializer, view: :normal
    association :municipio, blueprint: MunicipioSerializer, view: :normal
  end

  view :listagem_agenda do
    fields :nome
  end
end
