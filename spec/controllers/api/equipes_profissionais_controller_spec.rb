# frozen_string_literal: true

RSpec.describe Api::EquipesProfissionaisController do
  describe 'GET #index' do
    include_context 'with an authenticated token'

    let(:unidade_saude) { create(:unidade_saude) }
    let(:equipe) { create(:equipe, unidade_saude:) }
    let!(:equipe_profissionais) do
      advogado = create(:ocupacao, nome: 'Advogado')
      recepcionista = create(:ocupacao, nome: 'Recepcionista')
      medico = create(:ocupacao, nome: 'Médico')

      area_juridica = 1
      area_saude = 2
      area_administrativa = 3

      amanda = create(:profissional, nome: 'Amanda')
      bruno = create(:profissional, nome: 'Bruno')
      carlos = create(:profissional, nome: 'Carlos')

      [
        create(:equipe_profissional,
               equipe:, ocupacao: medico, codigo_micro_area: area_saude, profissional: amanda),
        create(:equipe_profissional,
               equipe:, ocupacao: recepcionista, codigo_micro_area: area_administrativa, profissional: bruno),
        create(:equipe_profissional,
               equipe:, ocupacao: advogado, codigo_micro_area: area_juridica, profissional: carlos)
      ]
    end

    let(:params) { { equipe_id: equipe.id } }

    before do
      get :index, params:
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of equipe_profissionais' do
      parsed_response = response.parsed_body
      expect(parsed_response['data'].size).to eq(3)
    end

    it 'returns the correct ids' do
      parsed_response = response.parsed_body
      response_ids = parsed_response['data'].pluck('id')
      expected_ids = equipe_profissionais.map(&:id)

      expect(response_ids).to match_array(expected_ids)
    end

    it 'returns the correct attributes for each equipe_profissional' do
      parsed_response = response.parsed_body
      equipe_profissional = equipe_profissionais.first
      response_profissional = parsed_response['data'].find { |ep| ep['id'] == equipe_profissional.id }

      expect(response_profissional['profissional']['nome']).to eq(equipe_profissional.profissional.nome)
      expect(response_profissional['ocupacao']['nome']).to eq(equipe_profissional.ocupacao.nome)
    end

    it 'includes pagination metadata' do
      parsed_response = response.parsed_body
      meta = parsed_response['meta']

      expect(meta['current_page']).to eq(1)
      expect(meta['total_pages']).to eq(1)
      expect(meta['total_count']).to eq(3)
    end

    context 'when is ordering by profissional_nome' do
      let(:params) { { equipe_id: equipe.id, order: 'profissional_nome' } }

      it 'returns the equipe_profissionais ordered by profissional_nome' do
        list = response.parsed_body['data'].map { |item| item['profissional']['nome'] }

        expect(list).to eq(%w[Amanda Bruno Carlos])
      end
    end

    context 'when is ordering by ocupacao_nome' do
      let(:params) { { equipe_id: equipe.id, order: 'ocupacao_nome' } }

      it 'returns the equipe_profissionais ordered by ocupacao_nome' do
        list = response.parsed_body['data'].map { |item| item['ocupacao']['nome'] }

        expect(list).to eq(%w[Advogado Médico Recepcionista])
      end
    end

    context 'when is ordering by codigo_micro_area' do
      let(:params) { { equipe_id: equipe.id, order: 'codigo_micro_area' } }

      it 'returns the equipe_profissionais ordered by codigo_micro_area' do
        list = response.parsed_body['data'].pluck('codigo_micro_area')

        expect(list).to eq([1, 2, 3])
      end
    end
  end
end
