# frozen_string_literal: true

RSpec.describe PoliticasAcesso::ListPoliticasAcessoService do
  describe '#call' do
    let!(:termo1) { create(:termo_uso, titulo: 'A', documento_tipo: 'politica_acesso') }
    let!(:termo2) { create(:termo_uso, titulo: 'B', documento_tipo: 'politica_acesso') }
    let!(:termo3) { create(:termo_uso, titulo: 'C', documento_tipo: 'politica_acesso') }

    context 'when successful' do
      it 'returns a Success result with paginated and sorted termos' do
        params = { page: 1, per_page: 2, order: 'titulo', order_direction: 'desc' }
        service = described_class.new(params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to contain_exactly(termo3, termo2)
      end

      it 'paginates results correctly' do
        params = { page: 1, per_page: 1 }
        service = described_class.new(params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to contain_exactly(termo1)
      end

      it 'sorts results correctly' do
        params = { order: 'titulo', order_direction: 'asc' }
        service = described_class.new(params)
        result = service.call

        expect(result).to be_success
        expect(result.data).to contain_exactly(termo1, termo2, termo3)
      end
    end
  end
end
