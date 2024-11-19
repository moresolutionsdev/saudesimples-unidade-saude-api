# frozen_string_literal: true

RSpec.describe AgendaMapaPeriodoRepository do
  let(:agenda) { create(:agenda) }

  let!(:periodo1) do
    create(:agenda_mapa_periodo, agenda:, data_inicial: '2024-10-01', data_final: '2024-10-05', inativo: false)
  end

  let!(:periodo2) do
    create(:agenda_mapa_periodo, agenda:, data_inicial: '2024-10-06', data_final: '2024-10-10', inativo: false)
  end

  let!(:periodo3) do
    create(:agenda_mapa_periodo, agenda:, data_inicial: '2024-10-11', data_final: '2024-10-15', inativo: true)
  end

  describe '.find_by_agenda_and_filters' do
    context 'when filtering by date range' do
      # rubocop:disable Rails/DynamicFindBy
      it 'returns periods within the given date range' do
        filters = {
          data_inicial: '2024-10-01',
          data_final: '2024-10-10'
        }

        result = described_class.find_by_agenda_and_filters(agenda.id, filters)

        expect(result).to contain_exactly(periodo1, periodo2)
      end
      # rubocop:enable Rails/DynamicFindBy
    end

    context 'when filtering by inactive status' do
      # rubocop:disable Rails/DynamicFindBy
      it 'returns periods that are active or inactive' do
        filters = {
          inativo: true
        }

        result = described_class.find_by_agenda_and_filters(agenda.id, filters)

        expect(result).to contain_exactly(periodo3)
      end
      # rubocop:enable Rails/DynamicFindBy
    end

    context 'when no filters are applied' do
      it 'returns all periods for the agenda' do
        result = described_class.find_by_agenda_and_filters(agenda.id, {})

        expect(result).to contain_exactly(periodo1, periodo2, periodo3)
      end
    end

    context 'when ordering results' do
      # rubocop:disable Rails/DynamicFindBy
      it 'returns periods ordered by data_inicial ascending by default' do
        filters = { order: 'data_inicial' }
        result = described_class.find_by_agenda_and_filters(agenda.id, filters)

        expect(result).to eq([periodo1, periodo2, periodo3])
      end
      # rubocop:enable Rails/DynamicFindBy
    end
  end

  describe '.buscar_conflitos' do
    let!(:profissional) { create(:profissional) }
    let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
    let!(:agenda) do
      create(:agenda, profissional:,
                      unidade_saude_ocupacao:)
    end

    it 'não retorna conflitos se não houver mapas de períodos válidos' do
      result = described_class.buscar_conflitos(
        profissional_id: profissional.id,
        unidade_saude_id: unidade_saude_ocupacao.id,
        data_inicial: Date.parse('2024-10-01'),
        data_final: Date.parse('2024-10-05')
      )

      expect(result).to be_empty
    end
  end

  describe '.update_with_associations' do
    let!(:mapa_periodo) do
      create(:agenda_mapa_periodo,
             data_inicial: '2024-01-01',
             data_final: '2024-01-31',
             possui_horario_distribuido: false,
             inativo: false)
    end

    context 'when the update is successful' do
      let(:params) do
        {
          data_inicial: '2024-10-01',
          data_final: '2024-10-31',
          possui_horario_distribuido: true,
          possui_tempo_atendimento_configurado: true,
          inativo: true,
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
              _destroy: false,
              mapa_horarios: [
                {
                  id: 1,
                  hora_inicio: '10:00',
                  hora_fim: '11:00',
                  nova_consulta: 60,
                  retorno: 60,
                  reserva_tecnica: 60,
                  regulacao: 60,
                  regulacao_retorno: 60
                }
              ]
            }
          ]
        }
      end

      it 'updates the mapa_periodo attributes' do
        described_class.update_with_associations(mapa_periodo.id, params)

        mapa_periodo.reload
        expect(mapa_periodo.dias_agendamento).to eq(5)
      end
    end
  end
end
