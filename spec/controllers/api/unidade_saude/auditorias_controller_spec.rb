# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::AuditoriasController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:auditoria_params) do
      {
        id: '1',
        order: 'date',
        order_direction: 'asc',
        page: '1',
        per_page: '10'
      }
    end

    context 'when service call is successful' do
      it 'returns a 200 status code and renders the result with meta data' do
        result = double('result', total_pages: 2, total_count: 20)

        allow(AuditsSerializer).to receive(:render_as_hash).and_return({ data: [],
                                                                         meta: { total_pages: 2, total_count: 20 } })

        allow(UnidadeSaude::AuditoriaService).to receive(:call)
          .with(1, auditoria_params.to_h)
          .and_return(success: result)

        get :index, params: auditoria_params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('meta')
        expect(response.body).to include('data')
      end
    end

    context 'when service call fails' do
      it 'returns a 422 status code and renders the error message' do
        error = 'Some error message'
        allow(UnidadeSaude::AuditoriaService).to receive(:call).with(1,
                                                                     auditoria_params.to_h).and_return(failure: error)

        get :index, params: auditoria_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(error)
      end
    end
  end
end
