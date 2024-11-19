# frozen_string_literal: true

class UpsertOcupacoesSigtapJob < ApplicationJob
  queue_as :default

  def perform(args)
    busca_e_processa_ocupacoes(args[:page], args[:per_page])
  rescue StandardError => e
    Rails.logger.error(e)
  end

  private

  def busca_e_processa_ocupacoes(page, per_page)
    loop do
      resposta = busca_ocupacoes_api(page, per_page)
      resposta[:data][:ocupacoes].each do |ocupacao|
        cria_ou_atualiza_ocupacao(ocupacao[:codigo_ocupacao], ocupacao[:nome_ocupacao])
      end
      page = resposta[:paginate][:next_page]
      break if page.nil?
    end
  end

  def busca_ocupacoes_api(page, per_page)
    response = SigtapApi::SigtapRepository.lista_ocupacoes(page:, per_page:)
    raise StandardError, 'IMPORT_API_ERROR' unless response[:success]

    response
  end

  def cria_ou_atualiza_ocupacao(codigo, nome)
    OcupacaoRepository.upsert_ocupacao(codigo, nome)
  end
end
