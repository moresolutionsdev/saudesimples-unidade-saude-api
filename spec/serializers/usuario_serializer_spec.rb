# frozen_string_literal: true

RSpec.describe UsuarioSerializer do
  let(:usuario) { build(:usuario) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(usuario)

      expect(result).to eq(
        id: usuario.id,
        email: usuario.email
      )
    end
  end
end
