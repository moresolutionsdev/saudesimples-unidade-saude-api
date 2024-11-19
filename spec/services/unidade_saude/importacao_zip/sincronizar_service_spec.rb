# frozen_string_literal: true

RSpec.describe UnidadeSaude::ImportacaoZip::SincronizarService do
  describe '#call' do
    subject(:service) { described_class.new.call }

    let(:job) { instance_double(SyncUnidadesDeSaudeWithCNESJob) }

    before do
      allow(SyncUnidadesDeSaudeWithCNESJob).to receive(:perform_later).and_return(job)
    end

    context 'quando a sincronização é bem-sucedida' do
      it 'retorna um sucesso' do
        expect(service).to be_a(Success)
      end

      it 'chama o job de sincronização' do
        service
        expect(SyncUnidadesDeSaudeWithCNESJob).to have_received(:perform_later).with(1)
      end
    end

    context 'quando ocorre uma exceção' do
      before do
        allow(SyncUnidadesDeSaudeWithCNESJob).to receive(:perform_later).and_raise(StandardError.new('Erro'))
        allow(Rails.logger).to receive(:error)
      end

      it 'retorna uma falha' do
        expect(service).to be_a(Failure)
        expect(service.instance_variable_get(:@error)).to eq('Não foi possivel sincronizar com CNES')
      end

      it 'loga o erro' do
        service
        expect(Rails.logger).to have_received(:error).with(instance_of(StandardError))
      end
    end
  end
end
