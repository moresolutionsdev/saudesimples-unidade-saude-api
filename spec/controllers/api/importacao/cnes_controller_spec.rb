# frozen_string_literal: true

RSpec.describe Api::Importacao::CNESController do
  describe 'POST /api/unidade_saude/importacao/cnes' do
    let(:valid_params) { %w[1234567 1234568 1234569] }
    let(:invalid_params) do
      %w[
        1234567
        1234568
        1234569
        1234567
        1234568
        1234569
        1234567
        1234568
        1234569
        1234567
        1234568
        1234569
      ]
    end

    include_context 'with an authenticated token'

    describe 'ao enviar uma lista de códigos CNES' do
      context 'quando a importação é realizada com sucesso' do
        before do
          allow_any_instance_of(UnidadeSaude::Importacao::CNESService).to receive(:call).and_return(
            Success.new(true)
          )
          post :create, params: { cnes: valid_params }, format: :json
        end

        describe 'deve fazer o upload corretamente' do
          it 'retorna http status 200' do
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'quando ocorre falha ao importar dados da CNES' do
        describe 'deve falhar ao não enviar dados para serem importados' do
          before do
            post :create, params: { cnes: [nil] }, format: :json
            allow(UnidadeSaude::Importacao::CNESService).to receive(:call).and_return(
              Failure.new('Erro na importação')
            )
          end

          it 'retorna http status unprocessable_entity', :vcr do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        describe 'deve falhar ao enviar mais de 10 cõdigos para serem importados' do
          before do
            post :create, params: { cnes: invalid_params }, format: :json
            allow(UnidadeSaude::Importacao::CNESService).to receive(:call).and_return(
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
