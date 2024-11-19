# frozen_string_literal: true

RSpec.describe UnidadeSaudeRepository, type: :repository do
  describe 'UnidadeSaudeRepository#create' do
    context 'com dados válidos' do
      let(:tipo_unidade) { create(:tipo_unidade) }
      let(:municipio) { create(:municipio) }
      let(:repository_params) do
        attributes_for(:unidade_saude, tipo_unidade_id: tipo_unidade.id, municipio_id: municipio.id)
      end

      it 'cria uma nova unidade de saúde' do
        nova_unidade_saude = described_class.create(repository_params)

        expect(nova_unidade_saude).to be_persisted
      end
    end

    context 'com dados inválidos' do
      let(:invalid_params) { { nome: nil } }

      it 'levanta um erro UnidadeSaude::UnidadeSaudeCriacaoError se a unidade de saúde não for válida' do
        expect { described_class.create(invalid_params) }.to raise_error(UnidadeSaude::UnidadeSaudeCriacaoError)
      end
    end
  end
end
