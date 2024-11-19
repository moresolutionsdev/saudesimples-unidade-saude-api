# frozen_string_literal: true

RSpec.describe DescricaoSubtipoUnidadeRepository, type: :repository do
  let!(:classificacao1) { create(:classificacao_cnes, codigo: '11') }
  let!(:classificacao2) { create(:classificacao_cnes, codigo: '22') }
  let!(:descricao_one) { create(:descricao_subtipo_unidade, codigo: '11', classificacao: classificacao1) }
  let!(:descricao_two) { create(:descricao_subtipo_unidade, codigo: '12', classificacao: classificacao1) }
  let!(:descricao_three) { create(:descricao_subtipo_unidade, codigo: '21', classificacao: classificacao2) }

  describe '.search_by_classificacao' do
    context 'quando o classificacao_cnes_id é fornecido' do
      it 'retorna apenas os registros com o classificacao_cnes_id fornecido' do
        result = described_class.search_by_classificacao(classificacao1.id)
        expect(result).to contain_exactly(descricao_one, descricao_two)
      end

      it 'não retorna registros para um classificacao_cnes_id que não existe' do
        result = described_class.search_by_classificacao(99)
        expect(result).to be_empty
      end
    end

    context 'quando o classificacao_cnes_id é nil' do
      it 'retorna todos os registros' do
        result = described_class.search_by_classificacao(nil)
        expect(result).to contain_exactly(descricao_one, descricao_two, descricao_three)
      end
    end
  end
end
