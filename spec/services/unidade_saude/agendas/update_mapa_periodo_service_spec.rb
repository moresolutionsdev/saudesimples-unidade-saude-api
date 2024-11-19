# frozen_string_literal: true

RSpec.describe UnidadeSaude::Agendas::UpdateMapaPeriodoService do
  describe '#call' do
    let(:mapa_periodo_id) { 1 }
    let(:params) do
      {
        data_inicial: '2024-10-01',
        data_final: '2024-10-31',
        possui_horario_distribuido: false,
        possui_tempo_atendimento_configurado: true,
        inativo: false,
        dias_agendamento: 10,
        data_liberacao_agendamento: '2024-09-25',
        tempo_atendimento: {
          nova_consulta: 60,
          retorno: 60,
          reserva_tecnica: 60,
          regulacao: 60,
          regulacao_retorno: 60
        }
      }
    end

    context 'when the update is successful' do
      let(:mapa_periodo) { double('AgendaMapaPeriodo') }

      before do
        allow(AgendaMapaPeriodoRepository).to receive(:update_with_associations)
          .with(mapa_periodo_id, params).and_return(mapa_periodo)
      end

      it 'returns success with the updated mapa_periodo' do
        result = described_class.call(mapa_periodo_id, params)

        expect(result).to be_success
        expect(result.data).to eq(mapa_periodo)
      end
    end

    context 'when the update fails' do
      let(:error_message) { 'Some error occurred' }

      before do
        allow(AgendaMapaPeriodoRepository).to receive(:update_with_associations)
          .and_raise(StandardError.new(error_message))
      end

      it 'returns failure with the error message' do
        result = described_class.call(mapa_periodo_id, params)

        expect(result).to be_failure
      end
    end
  end
end
