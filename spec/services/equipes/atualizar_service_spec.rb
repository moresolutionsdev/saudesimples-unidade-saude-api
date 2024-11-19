# frozen_string_literal: true

RSpec.describe Equipes::AtualizarService do
  describe '.call' do
    subject { described_class.call(params) }

    let(:unidade_saude) { create(:unidade_saude, id: 1) }
    let(:equipe) { create(:equipe, unidade_saude:, codigo: 111) }

    let(:params) { { id: equipe.id, nome: 'New Name' } }

    context 'when the execution is successful' do
      it 'returns a success object with the created equipe' do
        expect(subject).to be_a_success
        expect(subject.data).to be_a(Equipe)
      end
    end

    context 'when the equipe does not exist' do
      let(:params) { { id: 0 } }

      it 'returns a failure object' do
        expect(subject).to be_a_failure
      end
    end
  end
end
