# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::MapasPeriodosController do
  describe 'PUT #update' do
    include_context 'with an authenticated token'

    let(:mapa_periodo_id) { 1 }
    let(:agenda_id) { 1 }
    let(:valid_params) do
      {
        mapa_periodo: {
          data_inicial: '2024-10-01',
          data_final: '2024-10-31',
          possui_horario_distribuido: false,
          possui_tempo_atendimento_configurado: false,
          inativo: false,
          dias_agendamento: 5,
          data_liberacao_agendamento: '2024-09-25',
          tempo_atendimento: {
            nova_consulta: 60,
            retorno: 60,
            reserva_tecnica: 60,
            regulacao: 60,
            regulacao_retorno: 60
          },
          mapa_dias: [
            {
              id: 1,
              dia_atendimento_id: 1,
              mapa_horarios: [
                {
                  id: 1,
                  hora_inicio: '10:00',
                  hora_fim: '12:00',
                  nova_consulta: 30,
                  retorno: 20,
                  reserva_tecnica: 10,
                  regulacao: 5,
                  regulacao_retorno: 5,
                  hora_inicio_str: '10:00',
                  hora_fim_str: '12:00',
                  observacao: 'Observação de teste',
                  grupo_atendimento_id: 1
                }
              ]
            }
          ]
        }
      }
    end

    let(:serialized_mapa_periodo) { { id: 1, data_inicial: '2024-10-01', data_final: '2024-10-31' } }

    context 'when the update is successful' do
      it 'returns status 200 and serialized mapa_periodo' do
        allow(UnidadeSaude::Agendas::UpdateMapaPeriodoService).to receive(:call)
          .and_return(success: serialized_mapa_periodo)

        put :update,
            params: { agenda_id:, mapa_periodo_id:, mapa_periodo: valid_params[:mapa_periodo] }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the update fails' do
      it 'returns status 422 with error message' do
        allow(UnidadeSaude::Agendas::UpdateMapaPeriodoService).to receive(:call).and_return(failure: 'Some error')

        put :update,
            params: { agenda_id:, mapa_periodo_id:, mapa_periodo: valid_params[:mapa_periodo] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Some error')
      end
    end
  end
end
