# frozen_string_literal: true

RSpec.describe UnidadeSaude::BuscaUnidadeSaudeService, type: :service do
  describe '#call' do
    subject { described_class.call(unidade_saude.id) }

    let(:unidade_saude) { create(:unidade_saude) }

    context 'when the unidade_saude exists' do
      it 'retorna o sucesso com dados da unidade de saúde' do
        expect(subject).to be_success
        expect(subject.data).to eq(unidade_saude)
      end
    end

    context 'when the unidade_saude does not exist' do
      subject { described_class.call(99) }

      it 'retorna um erro informando que a unidade de saúde não foi encontrada' do
        expect(subject).to be_failure
        expect(subject.error).to eq('Não foi possível encontrar a unidade de saúde com id 99')
      end
    end
  end
end
