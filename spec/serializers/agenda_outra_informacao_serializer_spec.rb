# frozen_string_literal: true

RSpec.describe AgendaOutraInformacaoSerializer do
  before do
    Faker::UniqueGenerator.clear
  end

  let(:outra_informacao) do
    create(:outra_informacao, nome: 'Informação Teste', descricao: 'Descrição Teste', padrao: true)
  end
  let(:agenda_outra_informacao) { create(:agenda_outra_informacao, outra_informacao:) }

  describe '#render_as_hash' do
    it do
      result = described_class.render_as_hash(agenda_outra_informacao)

      expect(result).to include(
        id: agenda_outra_informacao.id,
        agenda_id: agenda_outra_informacao.agenda_id,
        outra_informacao: a_hash_including(
          id: outra_informacao.id,
          nome: 'Informação Teste',
          descricao: 'Descrição Teste',
          padrao: true
        )
      )
    end
  end
end
