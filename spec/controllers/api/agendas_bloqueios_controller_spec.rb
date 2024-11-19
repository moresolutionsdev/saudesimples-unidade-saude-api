# frozen_string_literal: true

RSpec.describe Api::AgendasBloqueiosController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:agenda_id) { 1 }

    context 'quando a requisição é bem-sucedida' do
      # rubocop:disable RSpec/VerifiedDoubleReference
      let(:result) { instance_double('Agendas::Bloqueios::Result', current_page: 1, total_pages: 1, total_count: 1) }
      # rubocop:enable RSpec/VerifiedDoubleReference
      let(:serialized_data) { { 'some_key' => 'some_value' } }

      before do
        allow(Agendas::Bloqueios::ListarService).to receive(:call).and_return(success: result)
        allow(controller).to receive(:serialize).with(result, AgendaBloqueioSerializer).and_return(serialized_data)
        get :index, params: { agenda_id: }
      end

      it 'retorna um status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renderiza os dados serializados corretamente' do
        expect(response.parsed_body).to eq(
          'data' => serialized_data,
          'meta' => {
            'current_page' => result.current_page,
            'total_pages' => result.total_pages,
            'total_count' => result.total_count
          }
        )
      end
    end

    context 'quando ocorre um erro na requisição' do
      let(:error_message) { 'Erro na requisição' }

      before do
        allow(Agendas::Bloqueios::ListarService).to receive(:call).and_return(failure: error_message)
        get :index, params: { agenda_id: }
      end

      it 'retorna um status 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renderiza a mensagem de erro' do
        expect(response.parsed_body).to eq(
          'code' => 422,
          'message' => error_message,
          'status' => 'unprocessable_entity'
        )
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with an authenticated token'
    let(:agenda_id) { '1' }
    let(:bloqueio_id) { '1' }
    let(:params) { { agenda_id:, id: bloqueio_id, replicar: nil } }

    before do
      allow(controller).to receive(:destroy_params).and_return(params)
    end

    context 'quando a remoção é bem-sucedida' do
      it 'retorna um status 204' do
        allow(Agendas::Bloqueios::RemoverService).to receive(:call).with(params).and_return(success: true)

        delete :destroy, params: { agenda_id:, id: bloqueio_id, replicar: nil }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando ocorre um erro na remoção' do
      let(:error_message) { 'Erro ao remover o bloqueio' }

      before do
        allow(Agendas::Bloqueios::RemoverService).to receive(:call).with(params).and_return(failure: error_message)
      end

      it 'retorna um status 422' do
        delete :destroy, params: { agenda_id:, id: bloqueio_id, replicar: nil }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renderiza a mensagem de erro' do
        delete :destroy, params: { agenda_id:, id: bloqueio_id, replicar: nil }

        expect(response.body).to include(error_message)
      end
    end
  end
end
