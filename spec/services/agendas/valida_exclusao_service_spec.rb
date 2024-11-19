# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agendas::ValidaExclusaoService, type: :service do
  let(:agenda_id) { 1 }
  let(:agendamento_ids) { [10, 20, 30] }
  let(:service) { described_class.new(agenda_id) }

  describe '#call' do
    before do
      allow(AgendamentoRepository).to receive(:agendamento_ids).with(agenda_id).and_return(agendamento_ids)
    end

    context 'when existe_agendamentos? returns true' do
      it 'returns true' do
        allow(AgendaRepository).to receive(:historico_agendamentos?).with(agenda_id, agendamento_ids).and_return(true)
        result = service.call

        expect(result.data).to eq('false')
      end
    end

    context 'when existe_agendamentos? returns false' do
      it 'returns false' do
        allow(AgendaRepository).to receive(:historico_agendamentos?).with(agenda_id, agendamento_ids).and_return(false)

        result = service.call
        expect(result.data).to eq('true')
      end
    end
  end

  describe '#agendamento_ids' do
    let(:agendamento_ids) { [1, 2, 3] }
    let(:agenda_id) { 1 }

    before do
      allow(AgendamentoRepository).to receive(:agendamento_ids).with(agenda_id).and_return(agendamento_ids)
    end

    it 'calls AgendamentoRepository.agendamento_ids with the correct agenda_id' do
      service.send(:agendamento_ids)

      expect(AgendamentoRepository).to have_received(:agendamento_ids).with(agenda_id)
    end

    it 'memoizes the result of agendamento_ids' do
      first_call = service.send(:agendamento_ids)
      expect(first_call).to eq(agendamento_ids)

      second_call = service.send(:agendamento_ids)
      expect(second_call).to eq(agendamento_ids)

      expect(AgendamentoRepository).to have_received(:agendamento_ids).once
    end
  end
end
