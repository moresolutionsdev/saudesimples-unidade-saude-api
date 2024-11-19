# frozen_string_literal: true

RSpec.describe UnidadeSaude::SearchSubtipoUnidadeService, type: :service do
  let!(:classificacao1) { create(:classificacao_cnes) }
  let!(:classificacao2) { create(:classificacao_cnes) }
  let!(:descricao1) { create(:descricao_subtipo_unidade, codigo: '11', classificacao_cnes_id: classificacao1.id) }
  let!(:descricao2) { create(:descricao_subtipo_unidade, codigo: '12', classificacao_cnes_id: classificacao1.id) }
  let!(:descricao3) { create(:descricao_subtipo_unidade, codigo: '21', classificacao_cnes_id: classificacao2.id) }

  describe '#call' do
    context 'quando o classificacao_cnes_id é fornecido' do
      it 'retorna apenas os registros com o classificacao_cnes_id fornecido' do
        service = described_class.new(classificacao_cnes_id: classificacao1.id)
        result = service.call
        expect(result.data).to contain_exactly(descricao1, descricao2)
      end
    end

    context 'quando o classificacao_cnes_id é nil' do
      it 'retorna todos os registros' do
        service = described_class.new(classificacao_cnes_id: nil)
        result = service.call
        expect(result.data).to contain_exactly(descricao1, descricao2, descricao3)
      end
    end

    context 'quando ocorre um erro' do
      it 'retorna uma falha com mensagem de erro' do
        allow(DescricaoSubtipoUnidade).to receive(:all).and_raise(StandardError)
        service = described_class.new(classificacao_cnes_id: classificacao1.id)
        result = service.call
        expect(result).to be_failure
      end
    end
  end
end
