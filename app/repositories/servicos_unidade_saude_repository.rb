# frozen_string_literal: true

class ServicosUnidadeSaudeRepository < ApplicationRepository
  # rubocop:disable Metrics/ParameterLists
  def self.create!(unidade_saude, codigo_classificacao, caracteristica_servico_id, codigo_cnes_terceiro,
                   atende_ambulatorial_nao_sus, atende_ambulatorial_sus, atende_hospitalar_nao_sus,
                   atende_hospitalar_sus, endereco_complementar_unidade_id, servico_id)
    ServicoUnidadeSaude.create!(
      unidade_saude:,
      codigo_classificacao:,
      caracteristica_servico_id:,
      codigo_cnes_terceiro:,
      atende_ambulatorial_nao_sus:,
      atende_ambulatorial_sus:,
      atende_hospitalar_nao_sus:,
      atende_hospitalar_sus:,
      endereco_complementar_unidade_id:,
      servico_id:
    )
  end
  # rubocop:enable Metrics/ParameterLists
end
