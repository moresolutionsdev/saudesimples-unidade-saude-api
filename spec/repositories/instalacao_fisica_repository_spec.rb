# frozen_string_literal: true

RSpec.describe InstalacaoFisicaRepository do
  describe '.find_by_id_or_name' do
    let!(:instalacao_fisica) { create(:instalacao_fisica, id: 1, nome: 'Instalacao 1') }

    context 'when searching by id' do
      it 'returns the record' do
        result = described_class.find_by_id_or_name(id: 1)
        expect(result).to eq([instalacao_fisica])
      end
    end

    context 'when searching by name' do
      it 'returns the record' do
        result = described_class.find_by_id_or_name(name: 'Instalacao 1')
        expect(result).to eq([instalacao_fisica])
      end
    end

    context 'when no record is found' do
      it 'returns nil' do
        result = described_class.find_by_id_or_name(id: 2)
        expect(result).to eq([])
      end
    end
  end
end
