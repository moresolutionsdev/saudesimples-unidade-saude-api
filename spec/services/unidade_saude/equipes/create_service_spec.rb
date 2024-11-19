# frozen_string_literal: true

RSpec.describe UnidadeSaude::Equipes::CreateService do
  describe '.call' do
    subject { described_class.call(params) }

    let(:unidade_saude) { create(:unidade_saude) }
    let(:params) { attributes_for(:equipe, unidade_saude_id: unidade_saude.id) }

    context 'when the execution is successful' do
      it 'returns a success object with the created equipe' do
        expect(subject).to be_a_success
        expect(subject.data).to be_a(Equipe)
      end
    end

    context 'when the execution fails' do
      before do
        allow(UnidadeSaude::EquipeRepository).to receive(:create!).and_raise(StandardError)
      end

      it 'returns a failure object' do
        expect(subject).to be_a_failure
      end
    end
  end
end
