# frozen_string_literal: true

RSpec.describe Api::UnidadeSaude::ProfissionalController do
  describe 'POST /api/unidade_saude/:unidade_saude_id/profissional' do
    include_context 'with an authenticated token'

    let(:mock_de_permissoes_validas) { { vinculo_de_profissional: { create: true } } }
    let(:mock_de_permissoes_invalidas) { { vinculo_de_profissional: { create: false } } }
    let(:unidade_saude) { create(:unidade_saude) }
    let(:profissional) { create(:profissional) }
    let(:ocupacao) { create(:ocupacao) }
    let(:params) do
      {
        unidade_saude_id: unidade_saude.id,
        profissional_id: profissional.id,
        ocupacao_id: ocupacao.id
      }
    end

    describe 'ao adicionar um profissional' do
      context 'quando user tem permissao de :manager' do
        before do
          allow_any_instance_of(AuthorizationService).to receive(:permissions).and_return(mock_de_permissoes_validas)
          post :create, params:
        end

        context 'quando profissional não possui cadastrado na unidade de saúde' do
          describe 'deve fazer vinculo entre unidade de saude e profissional' do
            it 'retorna http status ok' do
              expect(response).to have_http_status(:ok)
            end
          end
        end

        context 'quando profissional possui cadastrado na unidade de saúde' do
          before do
            allow_any_instance_of(AuthorizationService).to receive(:permissions).and_return(mock_de_permissoes_validas)
            post :create, params:
          end

          describe 'nao deve fazer vinculo entre unidade de saude e profissional' do
            it 'retorna http status unprocessable_entity' do
              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end
      end

      context 'quando user não tem permissao de :manager' do
        before do
          allow_any_instance_of(AuthorizationService).to receive(:permissions).and_return(mock_de_permissoes_invalidas)
          post :create, params:
        end

        describe 'nao deve fazer vinculo entre unidade de saude e profissional' do
          it 'retorna http status unprocessable_entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
