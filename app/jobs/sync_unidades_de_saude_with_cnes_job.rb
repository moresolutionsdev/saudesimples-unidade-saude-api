# frozen_string_literal: true

class SyncUnidadesDeSaudeWithCNESJob < ApplicationJob
  queue_as :default

  def perform(page)
    busca_e_processa_unidades_saude(page)
  rescue StandardError => e
    Rails.logger.error(e)
  end

  private

  def busca_e_processa_unidades_saude(page)
    loop do
      resposta = busca_unidades_saude_api(page)
      resposta[:data][:unidades_de_saude].each do |unidade_saude|
        cria_ou_atualiza_unidade_saude(unidade_saude[:cnes], define_objeto(unidade_saude))
      end
      page = resposta[:paginate][:next_page]
      break if page.nil?
    end
  end

  def busca_unidades_saude_api(page)
    response = CNESApi::CNESRepository.lista_unidade_saude(page:)
    raise StandardError, 'IMPORT_API_ERROR' unless response[:success]

    response
  end

  def cria_ou_atualiza_unidade_saude(cnes, object)
    UnidadeSaudeRepository.upsert_unidade_saude(cnes, object)
  end

  # rubocop:disable Metrics/AbcSize
  def define_objeto(unidade_saude)
    cep = UnidadeSaude::UnidadeSaudeEnderecoService.new.buscar_cep(unidade_saude[:enderecos][0][:cep])
    municipio = cep[:data][:municipio]
    estado = cep[:data][:estado]
    tipo_unidade = TipoUnidade.find_by(nome: unidade_saude[:tipo_unidade_saude])&.id
    descricao_subtipo = DescricaoSubtipoUnidade.find_by(codigo: unidade_saude[:codigo_subtipo_unidade_saude])&.id

    {
      nome: unidade_saude[:nome_fantasia],
      cnpj_numero: unidade_saude[:cnpj],
      codigo_cnes: unidade_saude[:cnes],
      tipo_unidade_id: tipo_unidade,
      descricao_subtipo_unidade_id: descricao_subtipo,
      telefone: unidade_saude[:telefone1],
      fax: unidade_saude[:fax],
      email: unidade_saude[:email],
      cep: unidade_saude[:enderecos][0][:cep],
      logradouro: unidade_saude[:enderecos][0][:logradouro],
      municipio_id: municipio.id,
      estado_id: estado.id,
      numero: unidade_saude[:enderecos][0][:numero],
      bairro: unidade_saude[:enderecos][0][:bairro],
      complemento: unidade_saude[:enderecos][0][:complemento]
    }
  end
  # rubocop:enable Metrics/AbcSize
end
