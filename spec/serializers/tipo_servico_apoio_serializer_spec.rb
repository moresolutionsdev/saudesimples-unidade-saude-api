# frozen_string_literal: true

RSpec.describe TipoServicoApoioSerializer do
  let(:tipo_servico_apoio) { build(:tipo_servico_apoio) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(tipo_servico_apoio)

      expect(result).to eq(
        id: tipo_servico_apoio.id,
        nome: tipo_servico_apoio.nome,
        codigo: tipo_servico_apoio.codigo
      )
    end
  end
end
