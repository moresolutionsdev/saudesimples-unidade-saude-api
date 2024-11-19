# frozen_string_literal: true

RSpec.describe NacionalidadeSerializer do
  let(:input) { create(:nacionalidade) }

  describe '#render_as_hash' do
    it do
      output = described_class.render_as_hash(input)

      expect(output).to include(
        id: input.id,
        nome: input.nome,
        codigo: input.codigo
      )
    end
  end
end
