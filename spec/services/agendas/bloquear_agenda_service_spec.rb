# frozen_string_literal: true

RSpec.describe Agendas::BloquearAgendaService do
  subject(:bloquear_agenda) { described_class.call(agenda_id: agenda.id, params:) }

  let!(:procedimento) { create(:procedimento) }
  let(:profissional) { create(:profissional) }
  let(:agenda) { create(:agenda, profissional:, procedimento:) }

  let(:data_inicio) { Date.current }
  let(:data_fim) { data_inicio + 1.month }
  let(:hora_inicio) { Time.zone.now }
  let(:hora_fim) { hora_inicio + 1.hour }
  let(:tipo_bloqueio_id) { create(:tipo_bloqueio).id }
  let(:replicar_bloqueio) { false }
  let(:params) do
    {
      data_inicio:,
      data_fim:,
      hora_inicio:,
      hora_fim:,
      replicar_bloqueio:,
      motivo: 'motivo',
      tipo_bloqueio_id:,
      agenda_id: agenda.id
    }
  end

  before do
    create_list(:agenda, 2, profissional:, procedimento:)
  end

  context 'quando bloqueio de mesma data' do
    let!(:agenda_bloqueio) { create(:agenda_bloqueio, agenda:, data_inicio:, data_fim:, hora_inicio:, hora_fim:) }

    it 'retorna objeto de falha com mensagem' do
      expect(bloquear_agenda).to be_a(Failure)
      expect(bloquear_agenda.error).to eq('Período de bloqueio já cadastrado')
    end
  end

  context 'quando nova data' do
    let(:bloqueio) { agenda.agendas_bloqueios.last }

    before do
      bloquear_agenda
    end

    it 'criar novo registro de bloqueio' do
      expect(agenda.agendas_bloqueios.size).to eq(1)
    end

    it 'bloqueio com as datas corretas' do
      expect(bloqueio.data_fim).to eq(data_fim)
      expect(bloqueio.data_inicio).to eq(data_inicio)
    end

    context 'quando replicar bloqueio' do
      let(:replicar_bloqueio) { true }
      let(:agendas) { AgendaRepository.all }

      before do
        create_list(:agenda, 5, profissional:, procedimento:)
      end

      it 'atualizar atributo de automatico' do
        expect(bloqueio.automatico).to be_truthy
      end

      it 'criar um bloqueio para cada agenda' do
        agendas.each do |agenda|
          bloqueios = agenda.agendas_bloqueios
          bloqueios.each do |bloqueio|
            expect(bloqueio.automatico).to be_truthy
          end
        end

        expect(agenda.agendas_bloqueios.size).to eq(1)
      end
    end
  end
end
