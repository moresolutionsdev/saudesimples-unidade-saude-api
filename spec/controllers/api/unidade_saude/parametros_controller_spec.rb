# frozen_string_literal: true

# rubocop:disable RSpec/StubbedMock, RSpec/MessageSpies

RSpec.describe Api::UnidadeSaude::ParametrosController do
  describe 'GET #index' do
    include_context 'with an authenticated token'
    let(:unidade_saude_id) { '88' }
    let(:parametros) { { exportacao_esus: true, validacao_municipe: 1 } }

    context 'when the service succeeds' do
      it 'returns success and the correct data' do
        expect(UnidadeSaude::BuscarParametrosService)
          .to receive(:call)
          .with({ 'unidade_saude_id' => unidade_saude_id }.to_h)
          .and_return(Success.new(parametros))

        get :index, params: { unidade_saude_id: }

        expect(response).to have_http_status(:ok)
        expect(json_response['data']).to eq(parametros.stringify_keys)
      end
    end

    context 'when service fails' do
      it 'returns a 422 status' do
        expect(UnidadeSaude::BuscarParametrosService)
          .to receive(:call)
          .with({ 'unidade_saude_id' => unidade_saude_id }.to_h)
          .and_return(Failure.new('Unidade de Saúde não encontrada'))

        get :index, params: { unidade_saude_id: }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to be_nil
      end
    end
  end

  def json_response
    response.parsed_body
  end
end

# rubocop:enable RSpec/StubbedMock, RSpec/MessageSpies
