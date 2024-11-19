# frozen_string_literal: true

RSpec.describe ProfissionalUnidadeSaudeSerializer do
  let(:profissional_vinculado) { create(:profissional_unidade_saude) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(profissional_vinculado)

      expect(result).to include(
        id: profissional_vinculado.id,
        ocupacao: a_hash_including(
          id: profissional_vinculado.ocupacao.id,
          nome: profissional_vinculado.ocupacao.nome
        ),
        profissional: a_hash_including(
          id: profissional_vinculado.profissional.id,
          nome: profissional_vinculado.profissional.nome
        )
      )
    end
  end
end
