# frozen_string_literal: true

RSpec.describe PoliticaAcessoRepository do
  describe '.create!' do
    let(:valid_params) do
      {
        titulo: 'Politica de Acesso',
        versao: '1.0',
        documento_tipo: 'politica_acesso',
        usuario_id: create(:usuario).id
      }
    end

    before do
      allow(TermoUso).to receive(:create!).and_call_original
    end

    it 'creates a new PoliticaAcesso with the given parameters' do
      described_class.create!(valid_params)

      expect(TermoUso).to have_received(:create!).with(valid_params)
    end
  end

  describe '.last_version' do
    let!(:termo_uso_mais_recente) { create(:termo_uso, documento_tipo: 'politica_acesso', versao: 3) }
    let!(:termo_uso_antigo) { create(:termo_uso, documento_tipo: 'politica_acesso', versao: 1) }

    context 'when there are termo_usos' do
      it 'returns the termo de uso with the highest version' do
        result = described_class.last_version

        expect(result).to eq(termo_uso_mais_recente)
      end
    end
  end

  describe '.search' do
    let!(:termo3) do
      create(:termo_uso, documento_tipo: 'politica_acesso', titulo: 'Política de Privacidade', created_at: '2024-07-01',
                         usuario: create(:usuario, email: 'user3@example.com'))
    end

    context 'when searching with multiple parameters' do
      it 'returns termos matching all specified parameters' do
        result = described_class.search(nome_arquivo: 'Política', data_criacao: '2024-07-01')
        expect(result).to contain_exactly(termo3)
      end
    end

    context 'when searching with no parameters' do
      it 'returns all termos' do
        result = described_class.search
        expect(result).to contain_exactly(termo3)
      end
    end
  end
end
