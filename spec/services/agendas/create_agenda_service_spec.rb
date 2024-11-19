# frozen_string_literal: true

RSpec.describe Agendas::CreateAgendaService do
  subject { described_class.new(valid_params) }

  let(:valid_params) do
    {
      unidade_saude_ocupacao_id: 1,
      profissional_id: 1,
      flags: { some_flag: true },
      grupo_atendimento_id: 1,
      equipamento_utilizavel_id: 1,
      procedimento_id: 1,
      data_inicio: '2024-09-19',
      data_fim: '2024-09-20',
      horario_inicio: '09:00',
      horario_fim: '10:00'
    }
  end

  describe 'private methods' do
    describe '#validate_flags' do
      subject { described_class.new(params) }

      context 'when possui_horario_distribuido and possui_tempo_atendimento_configurado are both true' do
        let(:params) do
          {
            mapa_periodos: [
              { possui_horario_distribuido: true, possui_tempo_atendimento_configurado: true }
            ]
          }
        end

        it 'raises an error' do
          expect { subject.send(:validate_flags) }.to raise_error(
            RuntimeError,
            'campos "possui_horario_distribuido" e "possui_tempo_atendimento_configurado" não podem ambos ser true.'
          )
        end
      end
    end

    describe '#validate_equipamento_utilizavel' do
      subject { described_class.new(params) }

      context 'when equipamento_utilizavel_id is nil' do
        let(:params) do
          {
            equipamento_utilizavel_id: nil
          }
        end

        it 'raises an error' do
          expect { subject.send(:validate_equipamento_utilizavel) }.not_to raise_error
        end
      end
    end

    describe '#validate_procedimento_id' do
      it 'raises an error if procedimento_id is invalid' do
        invalid_params = valid_params.merge(procedimento_id: nil)
        service = described_class.new(invalid_params)

        expect { service.send(:validate_procedimento_id) }.to raise_error(RuntimeError, 'Procedimento inválido')
      end
    end

    describe '#validate_conflito_datas' do
      subject { described_class.new(params) }

      context 'when there is no date conflict' do
        let(:params) { { mapa_periodos: [{ data_inicial: '2024-09-19', data_final: '2024-09-20' }] } }

        it 'does not raise an error' do
          expect { subject.send(:validate_conflito_datas) }.not_to raise_error
        end
      end

      context 'when there is a date conflict' do
        let(:params) do
          { mapa_periodos: [
            { data_inicial: '2024-09-19', data_final: '2024-09-25' },
            { data_inicial: '2024-09-20', data_final: '2024-09-30' }
          ] }
        end

        it 'raises an error' do
          expect do
            subject.send(:validate_conflito_datas)
          end.to raise_error(StandardError, /Conflito de datas encontrado entre períodos./)
        end
      end
    end

    describe '#validate_conflito_horarios' do
      subject { described_class.new(params) }

      context 'when there is no time conflict' do
        let(:params) do
          { mapa_periodos: [
            { mapa_dias: [
              { mapa_horarios: [
                { hora_inicio: '10:00', hora_fim: '10:30' },
                { hora_inicio: '11:00', hora_fim: '12:00' }
              ] }
            ] }
          ] }
        end

        it 'does not raise an error' do
          expect { subject.send(:validate_conflito_horarios) }.not_to raise_error
        end
      end

      context 'when there is a time conflict' do
        let(:params) do
          { mapa_periodos: [
            { mapa_dias: [
              { mapa_horarios: [
                { hora_inicio: '10:00', hora_fim: '10:30' },
                { hora_inicio: '14:00', hora_fim: '15:00' },
                { hora_inicio: '10:31', hora_fim: '11:00' },
                { hora_inicio: '14:31', hora_fim: '17:00' }
              ] }
            ] }
          ] }
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
