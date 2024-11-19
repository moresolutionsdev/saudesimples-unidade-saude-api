# frozen_string_literal: true

RSpec.describe ServicoApoio::BuscarServicosApoioService do
  describe '#call' do
    subject { described_class.call(params) }

    let!(:tipo_unidade) { create(:tipo_unidade) }
    let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:) }
    let!(:tipo_servico_apoio) { create(:tipo_servico_apoio) }
    let!(:caracteristica_servico) { create(:caracteristica_servico) }
    let!(:servico_apoio) do
      create(:servico_apoio, unidade_saude:, tipo_servico_apoio:, caracteristica_servico:)
    end

    let(:params) { { unidade_saude_id: unidade_saude.id } }

    it 'returns a list of services' do
      expect(subject).to be_success
      expect(subject.data).to eq([servico_apoio])
    end

    context 'with pagination' do
      before do
        5.times do
          create(:servico_apoio, unidade_saude:)
        end
      end

      it 'returns the first page with 3 services' do
        params[:page] = 1
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end

      it 'returns the second page with 3 services' do
        params[:page] = 2
        params[:per_page] = 3

        expect(subject).to be_success
        expect(subject.data.size).to eq(3)
        expect(subject.data.total_pages).to eq(2)
        expect(subject.data.total_count).to eq(6)
      end
    end
  end
end
