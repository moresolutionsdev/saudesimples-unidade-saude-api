# frozen_string_literal: true

RSpec.describe TermosUso::CreateTermoUsoService do
  let(:params) do
    {
      titulo: 'Termo de Uso',
      versao: 1,
      usuario_id: create(:usuario).id,
      documento_tipo: 'termo_uso',
      documento_arquivo: fixture_file_upload(Rails.root.join('spec/fixtures/files/teste_pdf.pdf'), 'application/pdf')
    }
  end

  describe '#call' do
    context 'when successful' do
      it 'creates a TermoUso and returns success' do
        service = described_class.new(params)
        result = service.call

        expect(result).to be_a(Success)
        expect(result.data).to be_a(TermoUso)
        expect(TermoUso.last.titulo).to eq('Termo de Uso')
      end
    end
  end
end
