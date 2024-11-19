# frozen_string_literal: true

RSpec.describe ServicoApoioSerializer do
  let(:servico_apoio) { build(:servico_apoio, id: 1) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(servico_apoio)

      expect(result).to eq(
        id: 1,
        tipo_servico_apoio: {
          id: servico_apoio.tipo_servico_apoio.id,
          nome: servico_apoio.tipo_servico_apoio.nome,
          codigo: servico_apoio.tipo_servico_apoio.codigo
        },
        caracteristica_servico: {
          id: servico_apoio.caracteristica_servico.id,
          nome: servico_apoio.caracteristica_servico.nome,
          codigo: servico_apoio.caracteristica_servico.codigo
        },
        actions: {
          delete: false
        }
      )
    end
  end
end
