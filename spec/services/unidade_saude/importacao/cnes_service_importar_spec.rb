# frozen_string_literal: true

RSpec.describe UnidadeSaude::Importacao::CNESService, type: :service do
  let(:params) { ['2038013'] }
  let(:service) { described_class.new(params) }
  let!(:municipio) { create(:municipio) }

  let(:unidade_saude_api_response) do
    {
      success: true,
      data: {
        unidades_de_saude: [{
          id: 22,
          nome_fantasia: 'CAPS A D ALCOOL E DROGAS HORTOLANDIA',
          cnpj: '67995027000132',
          cnes: '2038013',
          tipo_unidade_saude: '70',
          descricao_tipo_unidade_saude: 'CENTRO DE ATENCAO PSICOSSOCIAL',
          codigo_subtipo_unidade_saude: '005',
          descricao_subtipo_unidade_saude: 'CAPS ALCOOL E DROGA',
          telefone1: '',
          telefone2: '',
          fax: '',
          email: '',
          created_at: '2024-06-10T22:58:57.937Z',
          enderecos: [{
            id: 23,
            ownerable_type: 'UnidadeSaude',
            ownerable_id: 22,
            cep: '13184060',
            uf: 'SP',
            logradouro: 'RUA JOAO FRUCTUOSO MIRANDA FILHO',
            numero: '460',
            bairro: 'PQ ORTOLANDIA',
            codigo_ibge: '3519071',
            complemento: '',
            ponto_referencia: '',
            created_at: '2024-06-10T22:58:58.029Z'
          }],
          equipes: [],
          complexidades: [{
            id: 33,
            unidade_saude_id: 22,
            sigla: 'MC',
            created_at: '2024-06-10T22:58:58.122Z'
          }],
          lotacoes: []
        }]
      }
    }
  end

  let(:busca_cep_response) do
    {
      busca_cep: {
        cep: '13183090',
        logradouro: 'São Francisco de Assis',
        bairro: 'Vila Real',
        localidade: 'Hortolândia',
        uf: 'SP',
        ibge: '3519071',
        tipo: 'Avenida',
        id: nil
      },
      municipio: {
        id: municipio.id,
        nome: 'HORTOLÂNDIA',
        ibge: '351907',
        estado_id: 16,
        pode_aderir_pse: false,
        pode_aderir_pronasci: false,
        programa_territorio_cidadania: false,
        pertence_amazonia_legal: false,
        tipo_cadastro_municipio_id: nil,
        aderiu_pacto_gestao: false,
        tipo_envio_base_municipio_id: nil,
        pode_enviar_datasus: false,
        pacto_cib: false,
        pleno: false,
        competencia_inicial_pacto: nil,
        competencia_final_pacto: nil,
        competencia_inicial_cib_sas: nil,
        competencia_final_cib_sas: nil,
        possui_mac: false,
        populacao: nil,
        densidade_demografica: nil,
        competencia_inicial_mac: nil,
        competencia_ultima_base_exportada_datasus: nil,
        ibge_verificador: '3519071'
      },
      estado: {
        id: 25,
        nome: 'São Paulo',
        uf: 'SP',
        pais_id: 24,
        codigo_dne: '26'
      },
      logradouro: {
        id: 152_722,
        municipio_id: 4926,
        tipo_logradouro_id: 11,
        nome: 'São Francisco de Assis',
        bairro: 'Vila Real',
        cep: '13183-090'
      }
    }
  end

  before do
    stub_request(
      :get, "#{UnidadeSaude::Importacao::CNESService::BASE_URL}#{UnidadeSaude::Importacao::CNESService::IMPORT_API_URL}"
    )
      .to_return(
        status: 200, body: unidade_saude_api_response.to_json, headers: { 'Content-Type' => 'application/json' }
      )

    allow(UnidadeSaude::UnidadeSaudeEnderecoService).to receive(:new).and_return(double(buscar_cep: busca_cep_response))
    allow(UnidadeSaudeRepository).to receive(:search_by_cnes).with('2038013').and_return([])
    allow(UnidadeSaudeRepository).to receive(:new).and_return(double(create: double(id: 1)))
    allow(ClassificacaoUnidadeSaudeRepository)
      .to receive_messages(search_by_codigo: [build(:classificacao_cnes)])
    allow(DescricaoSubtipoUnidade)
      .to receive_messages(where: [build(:descricao_subtipo_unidade)], create: [build(:descricao_subtipo_unidade)])
  end

  describe '#call' do
    it 'returns success when all operations succeed', :vcr do
      unidade_saude = create(:unidade_saude, codigo_cnes: '2038014')
      allow(UnidadeSaudeRepository).to receive(:search_by_cnes).with('2038014').and_return([unidade_saude])
      allow(unidade_saude).to receive(:update).and_return(true)
      allow(service).to receive(:prepara_dados_unidade_saude)

      result = service.call

      expect(result).to be_a(Success)
    end

    it 'handles missing CNES' do
      service_with_empty_cnes = described_class.new([])
      result = service_with_empty_cnes.call

      expect(result).to be_a(Failure)
      expect(result.error).to eq('CNES_EMPTY')
    end

    it 'handles API error response' do
      stub_request(
        :get, 'https://saudesimples-importacao-cnes-api.qa.om30.cloud/api/v1/unidades_saude?cnes=%5B:cnes,%20%5B%222038013%22%5D%5D'
      )
        .to_return(
          status: 200, body: { success: false }.to_json, headers: { 'Content-Type' => 'application/json' }
        )

      result = service.call

      expect(result).to be_a(Failure)
    end

    it 'updates an existing unidade saude', :vcr do
      unidade_saude = create(:unidade_saude, codigo_cnes: '2038013')
      allow(UnidadeSaudeRepository).to receive(:search_by_cnes).with('2038013').and_return([unidade_saude])
      allow(unidade_saude).to receive(:update).and_return(true)
      allow(service).to receive(:prepara_dados_unidade_saude)

      result = service.call

      expect(result).to be_a(Success)
    end
  end
end
