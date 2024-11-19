# frozen_string_literal: true

RSpec.describe ClassificacaoUnidadeSaudeRepository, type: :repository do
  describe '.all' do
    it 'retorna todos os registros de ClassificacaoCNES ordenados por nome' do
      classificacao1 = create(:classificacao_cnes, nome: 'Cardiologia', codigo: 'CD')
      classificacao2 = create(:classificacao_cnes, nome: 'Ginecologia', codigo: 'GC')
      classificacao3 = create(:classificacao_cnes, nome: 'Pediatria', codigo: 'PD')

      result = described_class.all

      expect(result).to eq([classificacao1, classificacao2, classificacao3].sort_by(&:nome))
    end
  end
end
