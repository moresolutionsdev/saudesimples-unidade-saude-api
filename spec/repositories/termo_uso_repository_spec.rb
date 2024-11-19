# frozen_string_literal: true

RSpec.describe TermoUsoRepository do
  let!(:termo1) do
    create(:termo_uso, titulo: 'Contrato de Uso', created_at: '2024-07-01',
                       usuario: create(:usuario, email: 'user1@example.com'))
  end
  let!(:termo2) do
    create(:termo_uso, titulo: 'Termo de Aceite', created_at: '2024-07-02',
                       usuario: create(:usuario, email: 'user2@example.com'))
  end
  let!(:termo3) do
    create(:termo_uso, titulo: 'Política de Privacidade', created_at: '2024-07-01',
                       usuario: create(:usuario, email: 'user3@example.com'))
  end

  describe '.search' do
    context 'when searching by title' do
      it 'returns termos matching the title' do
        result = described_class.search(nome_arquivo: 'Contrato')
        expect(result).to contain_exactly(termo1)
      end
    end

    context 'when searching by creation date' do
      it 'returns termos created on the specified date' do
        result = described_class.search(data_criacao: '2024-07-01')
        expect(result).to contain_exactly(termo1, termo3)
      end
    end

    context 'when searching by email' do
      it 'returns termos associated with the user email' do
        result = described_class.search(email_usuario: 'user2@example.com')
        expect(result).to contain_exactly(termo2)
      end
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
        expect(result).to contain_exactly(termo1, termo2, termo3)
      end
    end
  end
end
