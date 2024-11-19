# frozen_string_literal: true

RSpec.describe UnidadeSaude::ImportacaoZip::EnvioCNESService, type: :service do
  let(:envio_cnes_service) { described_class }
  let(:service) { envio_cnes_service.new(params) }

  let(:valid_file) do
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/XmlParaESUS31_351907-05-05-2024.zip'))
  end
  let(:invalid_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.jpg')) }

  describe '#call' do
    context 'quando o arquivo é válido' do
      it 'deve chamar o CNESApi::CNESRepository.importar_arquivo_zip e retornar sucesso' do
        allow(CNESApi::CNESRepository).to receive(:importar_arquivo_zip).and_return({ success: true })

        valid_file.content_type = 'application/zip'
        result = envio_cnes_service.call({ file: valid_file })

        expect(result).to be_a(Success)
      end
    end

    context 'quando o arquivo excede o tamanho máximo' do
      before do
        allow(valid_file).to receive(:size).and_return(15.megabytes)
      end

      it 'deve levantar uma exceção com mensagem informativa' do
        allow(CNESApi::CNESRepository).to receive(:importar_arquivo_zip).and_return({ success: true })

        valid_file.content_type = 'application/zip'
        result = envio_cnes_service.call({ file: valid_file })

        expect(result).to be_a(Failure)
      end
    end

    context 'quando o tipo do arquivo é inválido' do
      it 'deve levantar uma exceção com mensagem informativa' do
        allow(CNESApi::CNESRepository).to receive(:importar_arquivo_zip).and_return({ success: true })

        result = envio_cnes_service.call({ file: valid_file })

        expect(result).to be_a(Failure)
      end
    end

    context 'quando a API retorna um erro' do
      it 'deve levantar uma exceção e retornar um Failure' do
        allow(CNESApi::CNESRepository).to receive(:importar_arquivo_zip).and_return({ success: false,
                                                                                      error: 'Erro na API' })
        valid_file.content_type = 'application/zip'

        result = envio_cnes_service.call({ file: valid_file })

        expect(result).to be_a(Failure)
      end
    end
  end
end
