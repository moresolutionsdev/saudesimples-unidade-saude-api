# frozen_string_literal: true

RSpec.describe Agendas::CreateMapaPeriodoService do
  subject { described_class.new(agenda.id, valid_params) }

  let!(:agenda) { create(:agenda) }
  let(:valid_params) do
    {
      data_inicial: '2024-09-19',
      data_final: '2024-09-20',
      possui_horario_distribuido: false,
      possui_tempo_atendimento_configurado: false,
      inativo: false,
      dias_agendamento: 2,
      data_liberacao_agendamento: '2024-09-18',
      tempo_atendimento: {
        nova_consulta: 60,
        retorno: 60,
        reserva_tecnica: 60,
        regulacao: 60,
        regulacao_retorno: 60
      },
      mapa_dias: [
        {
          dia_atendimento_id: 1,
          mapa_horarios: [{
            hora_inicio: '09:00',
            hora_fim: '10:00',
            retorno: 60,
            nova_consulta: 1,
            reserva_tecnica: 1,
            regulacao: 1,
            regulacao_retorno: 1,
            hora_inicio_str: '09:00',
            hora_fim_str: '10:00',
            observacao: 'observacao',
            grupo_atendimento_id: nil
          }]
        }
      ]
    }
  end

  describe '#call' do
    context 'when service runs successfully' do
      it 'returns a Success object' do
        result = subject.call
        expect(result.success?).to be true
      end

      it 'creates a new agenda_mapa_periodo' do
        expect { subject.call }.to change(AgendaMapaPeriodo, :count).by(1)
      end

      it 'creates a new agenda_mapa_periodo with the correct attributes' do
        subject.call
        expect(AgendaMapaPeriodo.last.data_inicial).to eq(Date.parse('2024-09-19'))
        expect(AgendaMapaPeriodo.last.data_final).to eq(Date.parse('2024-09-20'))
        expect(AgendaMapaPeriodo.last.possui_horario_distribuido).to be false
        expect(AgendaMapaPeriodo.last.possui_tempo_atendimento_configurado).to be false
        expect(AgendaMapaPeriodo.last.inativo).to be false
        expect(AgendaMapaPeriodo.last.dias_agendamento).to eq(2)
        expect(AgendaMapaPeriodo.last.data_liberacao_agendamento).to eq(Date.parse('2024-09-18'))
        expect(AgendaMapaPeriodo.last.agenda_mapa_periodo_tempo_atendimentos.last.attributes).to eq(
          'agenda_mapa_periodo_id' => AgendaMapaPeriodo.last.id,
          'id' => AgendaMapaPeriodo.last.agenda_mapa_periodo_tempo_atendimentos.last.id,
          'nova_consulta' => 60,
          'retorno' => 60,
          'reserva_tecnica' => 60,
          'regulacao' => 60,
          'regulacao_retorno' => 60,
          'created_at' => AgendaMapaPeriodo.last.agenda_mapa_periodo_tempo_atendimentos.last.created_at,
          'updated_at' => AgendaMapaPeriodo.last.agenda_mapa_periodo_tempo_atendimentos.last.updated_at
        )
      end
    end
  end

  describe 'private methods' do
    describe '#validate_flags' do
      context 'when possui_horario_distribuido and possui_tempo_atendimento_configurado are both true' do
        before do
          valid_params[:possui_horario_distribuido] = true
          valid_params[:possui_tempo_atendimento_configurado] = true
        end

        it 'raises an error' do
          expect { subject.send(:validate_flags) }.to raise_error(
            RuntimeError,
            'campos "possui_horario_distribuido" e "possui_tempo_atendimento_configurado" não podem ambos ser true.'
          )
        end
      end
    end

    describe '#validate_conflito_horarios' do
      context 'when there is a time conflict' do
        before do
          valid_params[:mapa_dias].first[:mapa_horarios] << {
            hora_inicio: '10:00',
            hora_fim: '10:30',
            retorno: 60,
            nova_consulta: 1,
            reserva_tecnica: 1,
            regulacao: 1,
            regulacao_retorno: 1,
            hora_inicio_str: '09:30',
            hora_fim_str: '10:30',
            observacao: 'observacao',
            grupo_atendimento_id: nil
          }
        end

        it 'raises an error' do
          expect do
            subject.send(:validate_conflito_horarios)
          end.to raise_error(StandardError,
                             /Conflito de horários dentro do mesmo dia encontrado no período./)
        end
      end
    end
  end
end
