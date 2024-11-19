# frozen_string_literal: true

RSpec.describe Endereco::Estados::BuscarMunicipiosPorEstadoService do
  describe '#call' do
    subject { described_class.call(params) }

    let(:estado) { create(:estado) }
    let(:params) { { estado_id: estado.id } }

    before do
      create_list(:municipio, 10, estado:)
    end

    context 'when the service is successful' do
      it 'returns a Success object with paginated municipios' do
        expect(subject).to be_a(Success)
      end
    end

    context 'when an error occurs' do
      let(:error_message) { 'Erro ao listar municipios' }

      before do
        allow(MunicipioRepository).to receive(:where).with(estado_id: estado.id).and_raise(StandardError)
        allow(Rails.logger).to receive(:error)
      end

      it 'returns a failure object' do
        expect(subject).to be_a(Failure)
      end

      it 'return error message' do
        expect(subject.error).to eq(error_message)
      end

      it 'logs the error' do
        subject

        expect(Rails.logger).to have_received(:error).with(instance_of(StandardError))
      end
    end
  end
end
