# frozen_string_literal: true

RSpec.describe UnidadeSaude::ServicoEspecializado::DeletarServicoEspecializadoService do
  describe '.call' do
    subject { described_class.call(servico_unidade_saude.id) }

    let(:servico_unidade_saude) { create(:servico_unidade_saude) }

    it 'return success' do
      expect(subject).to be_success
      expect(subject.data).to be_truthy
    end

    context 'when the removal fails' do
      before do
        allow(ServicoUnidadeSaude).to receive(:find).and_return(servico_unidade_saude)
        allow(servico_unidade_saude).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it 'returns failure' do
        expect(subject).to be_failure
        expect(subject.error).to eq('Erro ao remover o serviço especializado da unidade de saude')
      end
    end
  end
end
