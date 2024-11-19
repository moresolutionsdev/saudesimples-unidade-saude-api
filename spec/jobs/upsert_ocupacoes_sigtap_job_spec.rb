# frozen_string_literal: true

RSpec.describe UpsertOcupacoesSigtapJob do
  let(:page) { 1 }
  let(:per_page) { 10 }
  let(:ocupacoes_data) do
    {
      data: {
        ocupacoes: [
          { codigo_ocupacao: '001', nome_ocupacao: 'Médico' },
          { codigo_ocupacao: '002', nome_ocupacao: 'Enfermeiro' }
        ]
      },
      paginate: {
        next_page: 2
      },
      success: true
    }
  end

  let(:final_ocupacoes_data) do
    {
      data: {
        ocupacoes: [
          { codigo_ocupacao: '003', nome_ocupacao: 'Dentista' }
        ]
      },
      paginate: {
        next_page: nil
      },
      success: true
    }
  end

  before do
    allow(SigtapApi::SigtapRepository).to receive(:lista_ocupacoes).and_return(ocupacoes_data, final_ocupacoes_data)
    allow(OcupacaoRepository).to receive(:upsert_ocupacao)
  end

  it 'processa e insere/atualiza ocupacoes corretamente' do
    described_class.perform_now(page:, per_page:)

    expect(OcupacaoRepository).to have_received(:upsert_ocupacao).with('001', 'Médico')
    expect(OcupacaoRepository).to have_received(:upsert_ocupacao).with('002', 'Enfermeiro')
    expect(OcupacaoRepository).to have_received(:upsert_ocupacao).with('003', 'Dentista')
  end

  context 'quando ocorre um erro na API' do
    before do
      allow(SigtapApi::SigtapRepository).to receive(:lista_ocupacoes).and_raise(StandardError.new('IMPORT_API_ERROR'))
      allow(Rails.logger).to receive(:error)
    end

    it 'descreve o erro corretamente' do
      described_class.perform_now(page:, per_page:)
      expect(Rails.logger).to have_received(:error).with(instance_of(StandardError))
    end
  end
end
