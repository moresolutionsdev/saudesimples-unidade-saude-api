# frozen_string_literal: true

RSpec.describe SigtapApi::SigtapRepository, type: :repository do
  describe '.lista_ocupacoes', :vcr do
    let(:params) { { page: 1, per_page: 100 } }

    it 'retorna lista de ocupacoes' do
      response = described_class.lista_ocupacoes(params)

      expect(response).to be_an_instance_of(Hash)
      expect(response).to have_key(:data)
      expect(response[:data]).to have_key(:ocupacoes)
      expect(response[:data][:ocupacoes]).to be_an_instance_of(Array)
      expect(response[:data][:ocupacoes].first).to have_key(:codigo_ocupacao)
      expect(response[:data][:ocupacoes].first).to have_key(:nome_ocupacao)
    end
  end
end
