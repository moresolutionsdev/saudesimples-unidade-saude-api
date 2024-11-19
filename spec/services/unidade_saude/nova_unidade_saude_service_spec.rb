# frozen_string_literal: true

RSpec.describe UnidadeSaude::NovaUnidadeSaudeService, type: :service do
  subject(:result) { described_class.call(params) }

  let(:tipo_unidade) { create(:tipo_unidade) }
  let(:municipio) { create(:municipio) }
  let(:mantenedora) { double('Mantenedora', id: 1, persisted?: true, unidade_saude_id: nil) }

  let(:params) do
    attributes_for(:unidade_saude, tipo_unidade_id: tipo_unidade.id, municipio_id: municipio.id)
  end

  before do
    allow(Municipio).to receive(:find_by).and_return(municipio)
    allow(MantenedoraRepository).to receive_messages(
      find_or_initialize_by: mantenedora,
      update: true
    )
    allow(mantenedora).to receive(:save!).and_return(true)
  end

  describe 'cria uma nova unidade de saúde com sucesso' do
    it 'retorna sucesso' do
      allow(described_class).to receive(:call).and_return(create(:unidade_saude))
      expect(result).to be_a(UnidadeSaude)
      expect(result.nome).to eq(params[:nome])
    end
  end

  describe 'retorna um erro quando a criação da unidade de saúde falha' do
    let(:params) { attributes_for(:unidade_saude, nome: nil) }

    it 'retorna erro' do
      allow(described_class).to receive(:call).and_return(nil)
      expect(result).to be_nil
    end
  end
end
