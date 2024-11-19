# frozen_string_literal: true

RSpec.describe Api::ImportacaoZip::CNESController do
  describe 'POST /api/unidade_saude/importacao_zip/cnes' do
    let(:valid_file) do
      Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/XmlParaESUS31_351907-05-05-2024.zip'))
    end
    let(:invalid_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample.jpg')) }

    include_context 'with an authenticated token'

    describe 'ao enviar um arquivo para serviço de importação de CNES' do
      context 'quando arquivo enviado com sucesso para serviço de importação' do
        before do
          valid_file.content_type = 'application/zip'
          post :create, params: { cnes_file: { file: valid_file } }, format: :json
        end

        describe 'deve fazer o upload corretamente' do
          it 'retorna http status 204', :vcr do
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      context 'quando ocorre falha ao enviar para serviço de importação' do
        describe 'deve falhar ao fazer upload de arquivo invalido' do
          before do
            post :create, params: { cnes_file: { file: nil } }, format: :json
            allow(UnidadeSaude::ImportacaoZip::EnvioCNESService).to receive(:call).and_return(
              Failure.new('Erro na importação')
            )
          end

          it 'retorna http status unprocessable_entity', :vcr do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        describe 'deve falhar ao fazer upload de arquivo para serviço de importação' do
          before do
            post :create, params: { cnes_file: { file: invalid_file } }, format: :json
            allow(UnidadeSaude::ImportacaoZip::EnvioCNESService).to receive(:call).and_return(
              Failure.new('Erro na importação')
            )
          end

          it 'retorna http status unprocessable_entity', :vcr do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
