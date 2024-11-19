# frozen_string_literal: true

RSpec.describe AgendaBloqueioRepository do
  describe '.search' do
    let!(:agenda) { create(:agenda) } # Criando uma agenda para associar
    let!(:bloqueio_1) { create(:agenda_bloqueio, id: 1, agenda:, data_inicio: '2022-11-01') }
    let!(:bloqueio_2) { create(:agenda_bloqueio, id: 2, agenda:, data_inicio: '2022-12-01') }
    let!(:bloqueio_3) { create(:agenda_bloqueio, id: 3, agenda:, data_inicio: '2022-10-01') }

    context 'when searching with agenda_id' do
      it 'returns bloqueios associated with the given agenda_id' do
        result = described_class.search(agenda_id: agenda.id)

        expect(result).to contain_exactly(bloqueio_1, bloqueio_2, bloqueio_3)
      end
    end

    context 'when ordering by data_inicio ascending' do
      it 'returns bloqueios ordered by data_inicio in ascending order' do
        result = described_class.search(agenda_id: agenda.id, order: 'data_inicio', order_direction: 'asc')

        expect(result).to eq([bloqueio_3, bloqueio_1, bloqueio_2]) # Ordenado por data_inicio
      end
    end

    context 'when ordering by data_inicio descending' do
      it 'returns bloqueios ordered by data_inicio in descending order' do
        result = described_class.search(agenda_id: agenda.id, order: 'data_inicio', order_direction: 'desc')

        expect(result).to eq([bloqueio_2, bloqueio_1, bloqueio_3]) # Ordenado por data_inicio
      end
    end

    context 'when no agenda_id is provided' do
      it 'returns an empty array' do
        result = described_class.search

        expect(result).to be_empty
      end
    end
  end

  describe '.find_bloqueio' do
    let!(:agenda) { create(:agenda) }
    let!(:bloqueio) { create(:agenda_bloqueio, id: 1, agenda:) }

    context 'quando o bloqueio existe' do
      it 'retorna o bloqueio correto' do
        result = described_class.find_bloqueio(agenda.id, bloqueio.id)
        expect(result).to eq(bloqueio)
      end
    end

    context 'quando o bloqueio não existe' do
      it 'retorna nil' do
        result = described_class.find_bloqueio(agenda.id, -1)
        expect(result).to be_nil
      end
    end
  end

  describe '.find_bloqueios_to_replicate' do
    let!(:agenda) { create(:agenda) }
    let!(:outra_agenda) { create(:agenda) }
    let!(:bloqueio) do
      create(:agenda_bloqueio, id: 1, agenda:, data_inicio: '2024-10-01', data_fim: '2024-10-01', hora_inicio: '09:00',
                               hora_fim: '10:00')
    end
    let!(:bloqueio_para_replicar) do
      create(:agenda_bloqueio, id: 2, agenda: outra_agenda, data_inicio: '2024-10-01', data_fim: '2024-10-01',
                               hora_inicio: '09:00', hora_fim: '10:00')
    end
    let!(:bloqueio_diferente) do
      create(:agenda_bloqueio, id: 3, agenda: outra_agenda, data_inicio: '2024-11-01', data_fim: '2024-11-01',
                               hora_inicio: '11:00', hora_fim: '12:00')
    end

    it 'retorna bloqueios que podem ser replicados' do
      result = described_class.find_bloqueios_to_replicate(bloqueio)
      expect(result).to contain_exactly(bloqueio_para_replicar)
    end

    it 'não retorna bloqueios que não correspondem aos critérios de replicação' do
      result = described_class.find_bloqueios_to_replicate(bloqueio)
      expect(result).not_to include(bloqueio_diferente)
    end
  end
end
