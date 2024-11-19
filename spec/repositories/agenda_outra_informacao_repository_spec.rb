# frozen_string_literal: true

RSpec.describe AgendaOutraInformacaoRepository, type: :repository do
  let!(:agenda) { create(:agenda) }
  let!(:outra_informacao_1) { create(:outra_informacao) }
  let!(:agenda_outra_informacao_1) do
    create(:agenda_outra_informacao, agenda:, outra_informacao: outra_informacao_1)
  end

  describe '.search' do
    it 'returns records filtered by agenda_id' do
      result = described_class.search(agenda_id: agenda.id)

      expect(result).to include(agenda_outra_informacao_1)
    end

    it 'orders the results by id' do
      agenda_outra_informacao_2 = create(:agenda_outra_informacao, agenda:)

      result = described_class.search(agenda_id: agenda.id, order: 'id', order_direction: 'asc')
      expect(result.first).to eq(agenda_outra_informacao_1)
      expect(result.last).to eq(agenda_outra_informacao_2)
    end
  end
end
