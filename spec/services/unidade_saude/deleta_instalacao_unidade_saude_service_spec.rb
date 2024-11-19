# frozen_string_literal: true

RSpec.describe UnidadeSaude::DeletaInstalacaoUnidadeSaudeService, type: :service do
  describe '#call' do
    let(:instalacao_unidade_saude_id) { 1 }

    context 'when deletion is successful' do
      it 'returns a success result' do
        allow(InstalacaoUnidadeSaudeRepository).to receive(:destroy!)

        result = described_class.new(instalacao_unidade_saude_id).call

        expect(InstalacaoUnidadeSaudeRepository).to have_received(:destroy!).with(instalacao_unidade_saude_id)
        expect(result).to be_a(Success)
        expect(result.data).to be(true)
      end
    end

    context 'when deletion fails' do
      before do
        allow(InstalacaoUnidadeSaudeRepository).to receive(:destroy!).and_raise(ActiveRecord::ActiveRecordError)
        allow(Rails.logger).to receive(:error)
      end

      it 'returns a failure result' do
        result = described_class.new(instalacao_unidade_saude_id).call
        expect(result).to be_a(Failure)
        expect(result.error).to eq('Erro ao remover instalação fisica')
      end
    end
  end
end
