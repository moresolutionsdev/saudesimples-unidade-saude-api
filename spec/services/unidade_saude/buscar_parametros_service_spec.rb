# frozen_string_literal: true

RSpec.describe UnidadeSaude::BuscarParametrosService do
  describe '#call' do
    let(:unidade_saude_id) { 88 }
    let(:params) { { unidade_saude_id: } }
    let(:service) { described_class.new(params) }

    context 'when the service succeeds' do
      let(:parametros) { double('parametros', exportacao_esus: true, validacao_municipe: 1) }

      before do
        allow(UnidadeSaudeParametrosRepository)
          .to receive(:find_parametros_by_id)
          .with(unidade_saude_id)
          .and_return(parametros)
      end

      it 'returns success with the correct data' do
        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(parametros)
      end
    end

    context 'when the service fails' do
      before do
        allow(UnidadeSaudeParametrosRepository)
          .to receive(:find_parametros_by_id)
          .with(unidade_saude_id)
          .and_return(nil)
      end

      it 'returns failure with an error message' do
        result = service.call

        expect(result).not_to be_success
      end
    end
  end
end
