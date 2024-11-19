# frozen_string_literal: true

RSpec.describe UnidadeSaude::AtualizaUnidadeSaudeService, type: :service do
  subject(:result) { described_class.call(params) }

  let!(:tipo_unidade) { create(:tipo_unidade) }
  let!(:municipio) { create(:municipio) }
  let!(:unidade_saude) { create(:unidade_saude, tipo_unidade:, municipio:) }

  let(:params) do
    {
      id: unidade_saude.id,
      nome: 'Unidade de Saúde Teste',
      tipo_unidade_id: tipo_unidade.id,
      horarios_funcionamento: [],
      mantenedora: nil,
      tipo_pessoa_cnes_id: 2,
      municipio:
    }
  end

  it 'atualiza uma unidade de saúde com sucesso' do
    expect(result.data.nome).to eq('Unidade de Saúde Teste')
  end
end
