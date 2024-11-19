# frozen_string_literal: true

RSpec.describe CNESApi::CNESRepository, type: :repository do
  describe '.importar_arquivo_zip' do
    let(:valid_file) do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/XmlParaESUS31_351907-05-05-2024.zip'))
    end
    let(:invalid_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.jpg')) }
    let(:expected_response) do
      {
        data: {
          created_at: '2024-07-01T05:15:16.097Z',
          error_message: nil,
          hashMD5: '7854d6e79289cf56d565003629864e65',
          id: 69,
          status: 'COMPLETED'
        },
        paginate: nil,
        success: true
      }
    end

    context 'quando o envio é bem sucedido' do
      it 'deve chamar a API e retornar o resultado', :vcr do
        result = described_class.importar_arquivo_zip(valid_file)

        expect(result).to eq(expected_response)
      end
    end

    context 'quando a API retorna um erro' do
      let(:error_response) { { success: false, error: { file: ['deve ser do formato ZIP'] } } }

      it 'deve raisear uma exceção', :vcr do
        result = described_class.importar_arquivo_zip(invalid_file)

        expect(result).to eq(error_response)
      end
    end
  end
end
