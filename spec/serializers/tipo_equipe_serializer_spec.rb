# frozen_string_literal: true

RSpec.describe TipoEquipeSerializer do
  let(:tipo_equipe) { build(:tipo_equipe, codigo: '11', sigla: 'EQP1', descricao: 'Equipe Teste 1') }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(tipo_equipe)

      expect(result).to eq(
        id: tipo_equipe.id,
        codigo: tipo_equipe.codigo,
        sigla: tipo_equipe.sigla,
        descricao: tipo_equipe.descricao
      )
    end

    describe 'view: :with_label' do
      it do
        result = described_class.render_as_hash(tipo_equipe, view: :with_label)

        expect(result).to eq(
          id: tipo_equipe.id,
          codigo: tipo_equipe.codigo,
          sigla: tipo_equipe.sigla,
          descricao: tipo_equipe.descricao,
          label: "#{tipo_equipe.codigo} - #{tipo_equipe.sigla} - #{tipo_equipe.descricao}"
        )
      end
    end
  end
end
