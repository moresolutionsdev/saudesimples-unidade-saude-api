# frozen_string_literal: true

RSpec.describe Ferramentas::Parametrizacao::UpdateService do
  let!(:parametrizacao) { Ferramentas::Parametrizacao.create(uuid: 'uuid_padrao') }
  let(:params) { { id: parametrizacao.id, uuid: 'uuid_padrao' } }

  describe '#call' do
    context 'quando a atualização é bem-sucedida' do
      it 'retorna sucesso' do
        service = described_class.new(params)

        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(parametrizacao)
        expect(parametrizacao.reload.uuid).to eq('uuid_padrao')
      end
    end

    context 'quando ocorre um erro durante a atualização' do
      before do
        allow(Ferramentas::ParametrizacaoRepository).to receive(:find).and_return(parametrizacao)
        allow(parametrizacao).to receive(:update!).and_raise(StandardError, 'Erro ao atualizar')
      end

      it 'retorna falha' do
        service = described_class.new(params)

        result = service.call

        expect(result).to be_failure
        expect(result.error).to eq('Erro ao atualizar')
      end
    end
  end
end
