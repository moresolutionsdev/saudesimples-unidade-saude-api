# frozen_string_literal: true

RSpec.describe Agendas::ListarTiposBloqueiosService do
  describe '#call' do
    subject(:listar_tipo_bloqueios) { described_class.call(params) }

    let(:params) { { search_term: } }
    let!(:tipo_bloqueios) { create_list(:tipo_bloqueio, 3) }
    let(:search_term) { nil }

    context 'quando nenhum parametro de busca é enviado' do
      it 'retorna todos os tipos de bloqueio' do
        expect(listar_tipo_bloqueios.data.size).to eq(3)
      end
    end

    context 'quando parametro de busca é passado' do
      let!(:tipo_bloqueio_teste) { create(:tipo_bloqueio, nome: 'teste') }
      let(:search_term) { 'tes' }

      it 'retorna apenas os tipos de bloqueio com a condição' do
        expect(listar_tipo_bloqueios.data).to include(tipo_bloqueio_teste)
        expect(listar_tipo_bloqueios.data).not_to include(tipo_bloqueios)
      end

      it 'retorna quantidade correta' do
        expect(listar_tipo_bloqueios.data.size).to eq(1)
      end
    end
  end
end
