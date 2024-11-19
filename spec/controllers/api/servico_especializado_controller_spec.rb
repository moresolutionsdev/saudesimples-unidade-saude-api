# frozen_string_literal: true

RSpec.describe Api::ServicoEspecializadoController do
  describe 'DELETE /api/unidade_saude/:unidade_saude_id/servico_especializado/:id' do
    let(:unidade_saude) { create(:unidade_saude) }
    let(:servico_unidade_saude) { create(:servico_unidade_saude, unidade_saude:) }

    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        id: servico_unidade_saude.id
      }
    end

    context 'when user is authenticated' do
      include_context 'with an authenticated token'

      before do
        allow(AuthorizationService).to receive(:new).and_return(
          double(permissions: { servico_especializado: { delete: true } })
        )
      end

      it 'returns a no content response' do
        delete(:destroy, params:)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not authorized' do
      include_context 'with an authenticated token'

      before do
        allow(AuthorizationService).to receive(:new).and_return(
          double(permissions: { servico_especializado: { delete: false } })
        )
      end

      it 'returns a forbidden response' do
        delete(:destroy, params:)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      include_context 'with a invalid token'

      it 'returns a unauthorized response' do
        delete(:destroy, params:)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
