# frozen_string_literal: true

RSpec.describe Agendas::OutrasInformacoes::ListarService, type: :service do
  let!(:agenda) { create(:agenda) }
  let!(:outra_informacao_1) { create(:outra_informacao) }
  let!(:agenda_outra_informacao_1) do
    create(:agenda_outra_informacao, agenda:, outra_informacao: outra_informacao_1)
  end

  describe '#call' do
    it 'returns paginated results' do
      result = described_class.call({ agenda_id: agenda.id, page: 1, per_page: 5 })

      expect(result.success?).to be true
      expect(result.data).to be_a(ActiveRecord::Relation)
      expect(result.data.count).to eq(1)
      expect(result.data.first).to eq(agenda_outra_informacao_1)
    end

    it 'returns the correct total count' do
      result = described_class.call({ agenda_id: agenda.id })

      expect(result.data.count).to eq(1)
    end
  end
end
