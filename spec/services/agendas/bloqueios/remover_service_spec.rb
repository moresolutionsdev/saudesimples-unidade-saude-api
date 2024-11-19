# frozen_string_literal: true

RSpec.describe Agendas::Bloqueios::RemoverService do
  before do
    # Limpa o cache de valores únicos pra resolver o erro Retry limit exceeded for number
    Faker::UniqueGenerator.clear
  end

  let(:agenda) { create(:agenda) }
  let(:bloqueio) { create(:agenda_bloqueio, id: 1, agenda:) }

  describe '#call' do
    context 'quando o bloqueio existe' do
      it 'deve remover o bloqueio e retornar sucesso' do
        service = described_class.new(agenda_id: agenda.id, id: bloqueio.id)

        result = service.call
        expect(result).to be_success
        expect { bloqueio.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'quando o bloqueio não existe' do
      it 'deve retornar falha com mensagem de erro' do
        service = described_class.new(agenda_id: agenda.id, id: 'id_invalido')

        result = service.call
        expect(result).not_to be_success
        expect(result.error).to eq('Bloqueio não encontrado')
      end
    end

    context 'quando ocorre um erro ao remover o bloqueio' do
      before do
        allow_any_instance_of(AgendaBloqueio).to receive(:destroy).and_raise(StandardError)
      end

      it 'deve retornar falha com mensagem de erro' do
        service = described_class.new(agenda_id: agenda.id, id: bloqueio.id)

        result = service.call

        expect(result).not_to be_success
        expect(result.error).to eq('Erro ao remover bloqueio')
      end
    end
  end
end
