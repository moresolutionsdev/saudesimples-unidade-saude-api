# frozen_string_literal: true

RSpec.describe Equipes::ExcluirService do
  describe '.call' do
    subject { described_class.call(params) }

    let(:unidade_saude) { create(:unidade_saude, id: 1) }
    let(:equipe) { create(:equipe, unidade_saude:, codigo: 111) }
    let(:user) { create(:usuario) }

    let(:params) { { equipe_id: equipe.id, user: } }

    context 'when user has permission' do
      let!(:perfil_usuario) { create(:perfil_usuario, usuario_id: user.id) }

      it 'delete equipe' do
        subject

        expect { equipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'return success' do
        expect(subject).to be_a(Success)
      end
    end

    context 'when user has not permission' do
      it 'return failure' do
        expect(subject).to be_a(Failure)
      end
    end
  end
end
