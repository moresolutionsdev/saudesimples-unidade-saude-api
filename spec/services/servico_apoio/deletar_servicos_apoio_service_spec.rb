# frozen_string_literal: true

RSpec.describe ServicoApoio::DeletarServicosApoioService do
  describe '#call' do
    subject { described_class.call(servico_apoio.id) }

    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }
    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:servico_apoio) do
      create(:servico_apoio, unidade_saude:, tipo_servico_apoio:, caracteristica_servico:)
    end

    it 'returns success' do
      expect(subject).to be_success
      expect(subject.data).to be_truthy
    end

    context 'when the removal fails' do
      before do
        allow(ServicoApoio).to receive(:find).and_return(servico_apoio)
        allow(servico_apoio).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it 'returns failure' do
        expect(subject).to be_failure
        expect(subject.error).to eq('Erro ao remover o serviço de apoio')
      end
    end
  end
end
