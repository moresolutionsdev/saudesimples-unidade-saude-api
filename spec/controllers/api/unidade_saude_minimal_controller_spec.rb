# frozen_string_literal: true

RSpec.describe Api::UnidadeSaudeMinimalController do
  describe 'GET /api/unidade_saude/listagem_reduzida' do
    include_context 'with an authenticated token'

    let!(:unidade_saude1) { create(:unidade_saude, nome: 'Hospital A', exportacao_esus: false) }
    let!(:unidade_saude2) { create(:unidade_saude, nome: 'Posto de Saúde B', exportacao_esus: false) }

    context 'quando o retorn é bem sucedido' do
      it 'retorna lista de unidades de saude' do
        get :listagem_reduzida
        expect(response).to have_http_status(:ok)

        expect(response.parsed_body['data']).to eq([
          { 'id' => unidade_saude1.id, 'nome' => unidade_saude1.nome, 'codigo_cnes' => unidade_saude1.codigo_cnes,
            'exportacao_esus' => false },
          { 'id' => unidade_saude2.id, 'nome' => unidade_saude2.nome, 'codigo_cnes' => unidade_saude2.codigo_cnes,
            'exportacao_esus' => false }
        ])
      end
    end
  end
end
