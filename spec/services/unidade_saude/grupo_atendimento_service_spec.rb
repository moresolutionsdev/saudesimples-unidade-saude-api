# frozen_string_literal: true

RSpec.describe UnidadeSaude::GrupoAtendimentoService do
  describe '#call' do
    let(:params) { { profissional_id: 1, search_term: 'teste', unidade_saude_id: 1 } }
    let(:grupos_mock) { double('GrupoAtendimento') }

    context 'when the service call is successful' do
      before do
        allow(GrupoAtendimentoRepository).to receive(:filter).with(params).and_return(grupos_mock)
      end

      it 'returns a Success object with the filtered groups' do
        result = described_class.new(params).call

        expect(result).to be_a(Success)
      end
    end

    context 'when the service call fails' do
      let(:error_message) { 'An error occurred' }

      before do
        allow(GrupoAtendimentoRepository).to receive(:filter).with(params).and_raise(StandardError, error_message)
      end

      it 'returns a Failure object with the error message' do
        result = described_class.new(params).call

        expect(result).to be_a(Failure)
        expect(result.error).to eq(error_message)
      end
    end
  end
end
