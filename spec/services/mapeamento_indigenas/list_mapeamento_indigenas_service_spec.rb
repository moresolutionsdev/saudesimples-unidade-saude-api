# frozen_string_literal: true

RSpec.describe MapeamentoIndigenas::ListMapeamentoIndigenasService do
  describe '#call' do
    let!(:mapeamento_indigena) { create(:mapeamento_indigena) }

    context 'when successful' do
      it 'returns a Success result with paginated and sorted mapeamento_indigena' do
        params = { page: 1, per_page: 2 }
        service = described_class.new(params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to contain_exactly(mapeamento_indigena)
      end

      it 'paginates results correctly' do
        params = { page: 1, per_page: 1 }
        service = described_class.new(params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to contain_exactly(mapeamento_indigena)
      end
    end
  end
end
