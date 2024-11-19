# frozen_string_literal: true

RSpec.describe Agendas::BuscaConflitosService do
  describe '#call' do
    subject { described_class.new(params) }

    let(:profissional_id) { 1 }
    let(:unidade_saude_id) { 2 }
    let(:data_inicial) { Time.zone.today }
    let(:data_final) { Time.zone.today + 1.week }
    let(:params) do
      {
        profissional_id:,
        unidade_saude_id:,
        data_inicial:,
        data_final:
      }
    end

    context 'quando os parâmetros são válidos' do
      it 'retorna um objeto de sucesso com os conflitos' do
        allow_any_instance_of(described_class).to receive(:busca_conflitos).and_return([])

        result = subject.call

        expect(result.success?).to be true
      end
    end

    context 'quando ocorre um erro' do
      before do
        allow_any_instance_of(described_class).to receive(:busca_conflitos).and_raise(StandardError, 'Erro inesperado')
      end

      it 'retorna um objeto de falha com mensagem de erro' do
        result = subject.call

        expect(result).to be_a(Failure)
        expect(result.error[:error]).to eq('Não foi possível buscar os conflitos de agenda.')
      end
    end

    context 'quando todos os parâmetros estão válidos' do
      let(:params) do
        {
          profissional_id: 1,
          unidade_saude_id: 2,
          data_inicial: Time.zone.today,
          data_final: Time.zone.today + 1.week
        }
      end

      it 'retorna sucesso com os conflitos encontrados' do
        expect(subject.call).to be_a(Success)
      end
    end
  end
end
