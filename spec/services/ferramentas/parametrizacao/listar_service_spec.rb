# frozen_string_literal: true

RSpec.describe Ferramentas::Parametrizacao::ListarService do
  describe '#call' do
    context 'quando a parametrizacao é encontrada' do
      it 'retorna sucesso com a parametrizacao' do
        parametrizacao = double('Parametrizacao')
        allow(Ferramentas::ParametrizacaoRepository).to receive(:first).and_return(parametrizacao)

        service = described_class.new

        result = service.call

        expect(result).to be_success
        expect(result).to be_a_success
      end
    end

    context 'quando ocorre um erro' do
      it 'retorna falha com a mensagem de erro' do
        error_message = 'Erro ao buscar parametrizacao'
        allow(Ferramentas::ParametrizacaoRepository).to receive(:first).and_raise(StandardError.new(error_message))

        service = described_class.new

        result = service.call

        expect(result).to be_failure
      end
    end
  end
end
