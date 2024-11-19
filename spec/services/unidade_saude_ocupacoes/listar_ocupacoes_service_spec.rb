# frozen_string_literal: true

RSpec.describe UnidadeSaudeOcupacoes::ListarOcupacoesService do
  describe '#call' do
    subject(:service) { described_class.new(unidade_saude_id: unidade_saude.id, params:).call }

    let(:unidade_saude) { create(:unidade_saude) }
    let(:ocupacao) { create(:ocupacao, nome: 'termo') }
    let(:ocupacao_2) { create(:ocupacao) }
    let(:profissional_unidade_saude) { create(:profissional_unidade_saude, ocupacao: ocupacao_2) }
    let!(:unidade_saude_ocupacao) do
      create(:unidade_saude_ocupacao, unidade_saude:, ocupacao:)
    end
    let!(:unidade_saude_ocupacao_2) do
      create(:unidade_saude_ocupacao, unidade_saude:, ocupacao: ocupacao_2)
    end

    let(:params) { { profissional_id:, term: } }
    let(:profissional_id) { nil }
    let(:term) { nil }

    context 'quando unidade de saude possui ocupacoes' do
      it 'retorna ocupacoes' do
        expect(service.data.to_a.size).to eq(2)
      end

      it 'retorna objeto de success' do
        expect(service).to be_a(Success)
      end

      context 'quando filtro por profissional_id' do
        let(:profissional_id) { profissional_unidade_saude.profissional_id }

        it 'retorna apenas ocupacoes com esse profissional' do
          expect(service.data).to include(unidade_saude_ocupacao_2)
          expect(service.data).not_to include(unidade_saude_ocupacao)
        end
      end

      context 'quando filtro por termo' do
        let(:term) { 'termo' }

        it 'retorna apenas ocupação com nome igual ao termo' do
          expect(service.data).to include(unidade_saude_ocupacao)
        end
      end
    end
  end
end
