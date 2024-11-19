# frozen_string_literal: true

RSpec.describe PoliticasAcesso::CreatePoliticaAcessoService do
  let(:params) do
    {
      titulo: 'Politica Acesso',
      versao: 1,
      usuario_id: create(:usuario).id,
      documento_tipo: 'politica_acesso',
      documento_arquivo: fixture_file_upload(Rails.root.join('spec/fixtures/files/teste_pdf.pdf'), 'application/pdf')
    }
  end

  describe '#call' do
    context 'when successful' do
      it 'creates a PoliticaAcesso and returns success' do
        service = described_class.new(params)
        result = service.call

        expect(result).to be_a(Success)
        expect(result.data).to be_a(TermoUso)
        expect(TermoUso.last.titulo).to eq('Politica Acesso')
      end
    end
  end
end
