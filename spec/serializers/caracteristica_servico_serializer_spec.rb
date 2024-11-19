# frozen_string_literal: true

RSpec.describe CaracteristicaServicoSerializer do
  let(:caracteristica_servico) { build(:caracteristica_servico) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(caracteristica_servico)

      expect(result).to eq(
        id: caracteristica_servico.id,
        nome: caracteristica_servico.nome,
        codigo: caracteristica_servico.codigo
      )
    end
  end
end
