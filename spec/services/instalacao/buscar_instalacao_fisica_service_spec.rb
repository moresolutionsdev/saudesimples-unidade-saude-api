# frozen_string_literal: true

RSpec.describe Instalacao::BuscarInstalacaoFisicaService do
  describe '.call' do
    let!(:instalacao_fisica) { create(:instalacao_fisica, id: 1, nome: 'Instalacao 1', codigo: 'I1') }

    context 'when searching by id' do
      it 'returns the record' do
        result = described_class.call(id: instalacao_fisica.id)
        expect(result).to be_success
        expect(result.data).to eq([instalacao_fisica])
      end
    end

    context 'when searching by name' do
      it 'returns the record' do
        result = described_class.call(nome: instalacao_fisica.nome)
        expect(result).to be_success
        expect(result.data).to eq([instalacao_fisica])
      end
    end

    context 'when no record is found' do
      it 'returns a failure result' do
        result = described_class.call(id: 99)
        expect(result).to be_success
        expect(result.data).to eq([])
      end
    end

    context 'when an error occurs' do
      it 'returns a failure result' do
        allow(Rails.logger).to receive(:error)
        allow(InstalacaoFisicaRepository).to receive(:find_by_id_or_name).and_raise(StandardError)

        result = described_class.call(id: 99)
        expect(result).to be_failure
        expect(result.error).to eq('Falha ao buscar instalação física')
        expect(Rails.logger).to have_received(:error).once
      end
    end
  end
end
