# frozen_string_literal: true

class EquipamentoRepository < ApplicationRepository
  def self.all
    Equipamento.order(nome: :asc)
  end

  def self.search_by_nome(nome)
    Equipamento.where('nome ILIKE ?', "%#{nome}%").order(nome: :asc)
  end

  def self.search_by_unidade_saude(unidade_saude_id, order = 'equipamentos.nome', direction = 'asc')
    EquipamentoUnidadeSaude
      .includes(equipamento: :tipo_equipamento)
      .where(unidade_saude_id:)
      .order("#{order} #{direction}")
  end

  def self.add_to_unidade_saude(unidade_saude_id, params)
    equipamento = Equipamento.find(params[:equipamento_id])
    tipo_equipamento_id = equipamento.tipo_equipamento_id

    return nil if existe_equipamento_na_unidade?(unidade_saude_id, params[:equipamento_id])

    EquipamentoUnidadeSaude.create!(
      unidade_saude_id:,
      equipamento_id: params[:equipamento_id],
      tipo_equipamento_id:,
      qtde_existente: params[:qtde_existente],
      qtde_em_uso: params[:qtde_em_uso],
      disponivel_para_sus: params[:disponivel_para_sus]
    )
  end

  def self.remove_from_unidade_saude(id)
    EquipamentoUnidadeSaude.find(id).destroy
  end

  def self.existe_equipamento_na_unidade?(unidade_saude_id, equipamento_id)
    EquipamentoUnidadeSaude.exists?(
      unidade_saude_id:,
      equipamento_id:
    )
  end
end
