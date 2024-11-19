# frozen_string_literal: true

RSpec.describe Agendas::DeletaAgendaService do
  describe '#call' do
    subject(:service_call) { described_class.new(agenda_id).call }

    let(:agenda_id) { 1 }

    context 'quando a agenda existe e pode ser deletada' do
      before do
        allow(AgendaRepository).to receive(:exist?).with(agenda_id).and_return(true)
        allow(AgendamentoRepository).to receive(:agendamento_ids).with(agenda_id).and_return([])
        allow(AgendaRepository).to receive(:historico_agendamentos?).with(agenda_id, []).and_return(false)
        allow(AgendaRepository).to receive(:delete_agenda).with(agenda_id).and_return(true)
      end

      it 'retorna sucesso' do
        expect(service_call).to be_a(Success)
      end

      it 'chama o método de exclusão da agenda' do
        service_call
        expect(AgendaRepository).to have_received(:delete_agenda).with(agenda_id)
      end
    end

    context 'quando a agenda não existe' do
      before do
        allow(AgendaRepository).to receive(:exist?).with(agenda_id).and_return(false)
      end

      it 'retorna uma falha com mensagem de erro' do
        result = service_call
        expect(result.error).to eq('Agenda inválida')
      end
    end

    context 'quando a agenda tem histórico e não pode ser deletada' do
      before do
        allow(AgendaRepository).to receive(:exist?).with(agenda_id).and_return(true)
        allow(AgendamentoRepository).to receive(:agendamento_ids).with(agenda_id).and_return([100, 101])
        allow(AgendaRepository).to receive(:historico_agendamentos?).with(agenda_id, [100, 101]).and_return(true)
      end

      it 'retorna uma falha com mensagem de erro' do
        result = service_call

        expect(result.error).to eq('Agenda tem historico.')
      end
    end

    context 'quando ocorre um ArgumentError' do
      before do
        allow(AgendaRepository).to receive(:exist?).and_raise(ArgumentError, 'Argumento inválido')
      end

      it 'retorna uma falha com status 400' do
        result = service_call

        expect(result.error).to eq({ error: 'Argumento inválido', status: 400 })
      end
    end

    context 'quando ocorre um erro padrão' do
      before do
        allow(AgendaRepository).to receive(:exist?).and_raise(StandardError, 'Erro inesperado')
      end

      it 'retorna uma falha com a mensagem de erro' do
        result = service_call

        expect(result.error).to eq('Erro inesperado')
      end
    end
  end
end
