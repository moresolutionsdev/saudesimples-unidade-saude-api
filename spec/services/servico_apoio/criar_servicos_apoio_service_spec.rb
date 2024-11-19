# frozen_string_literal: true

RSpec.describe ServicoApoio::CriarServicosApoioService do
  describe '#call' do
    subject { described_class.call(params) }

    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }

    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        tipo_servico_apoio_id: tipo_servico_apoio.id,
        caracteristica_servico_id: caracteristica_servico.id
      }
    end

    context 'when valid' do
      it 'returns success' do
        expect(subject).to be_success
        expect(subject.data).to eq(ServicoApoio.last)
      end
    end

    context 'when invalid' do
      let!(:caracteristica_servico) { create(:caracteristica_servico, id: 1) }
      let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:, id: 1) }
      let!(:tipo_servico_apoio) { create(:tipo_servico_apoio, id: 1) }

      let(:params) do
        {
          unidade_saude_id: unidade_saude.id,
          tipo_servico_apoio_id: tipo_servico_apoio.id,
          caracteristica_servico_id: caracteristica_servico.id
        }
      end

      before do
        create(:servico_apoio,
               tipo_servico_apoio_id: tipo_servico_apoio.id,
               caracteristica_servico_id: caracteristica_servico.id,
               unidade_saude_id: unidade_saude.id)
      end

      it 'returns failure' do
        expect(subject).to be_failure
      end

      it 'returns the correct error message' do
        expect(subject.error[:unidade_saude_id]).to include(
          'Tipo de serviço já inserido, caso deseje modificar remova e adicione novamente.'
        )
      end
    end
  end
end
