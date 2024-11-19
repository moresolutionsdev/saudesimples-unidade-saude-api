# frozen_string_literal: true

RSpec.describe CaracteristicaServico::BuscarCaracteristicasServicosService do
  describe '#call' do
    context 'when success' do
      before do
        create(:caracteristica_servico)
      end

      it 'returns success' do
        expect(described_class.call).to be_success
      end

      it 'returns all caracteristicas_servicos' do
        expect(described_class.call.data).to eq(CaracteristicaServico.all)
      end
    end

    context 'when failure' do
      before do
        allow(CaracteristicaServico).to receive(:all).and_raise(StandardError)
      end

      it 'returns failure' do
        expect(described_class.call).to be_failure

        expect(described_class.call.error).to eq('Erro ao buscar características de serviços')
      end
    end
  end
end
