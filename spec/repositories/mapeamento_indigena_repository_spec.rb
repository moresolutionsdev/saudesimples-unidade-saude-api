# frozen_string_literal: true

RSpec.describe MapeamentoIndigenaRepository do
  describe '.search' do
    let!(:termo3) do
      create(:mapeamento_indigena, dsei: '12')
    end

    context 'when searching with multiple parameters' do
      it 'returns mapeamento_indigena matching all specified parameters' do
        result = described_class.search(search_term: '12')
        expect(result).to contain_exactly(termo3)
      end
    end

    context 'when searching with no parameters' do
      it 'returns all mapeamento_indigena' do
        result = described_class.search
        expect(result).to contain_exactly(termo3)
      end
    end
  end
end
