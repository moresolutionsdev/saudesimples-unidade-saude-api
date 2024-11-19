# frozen_string_literal: true

RSpec.describe UnidadeSaude::SearchService do
  describe '#call' do
    let(:health_unit1) do
      double('UnidadeSaude', id: 1, cpf_numero: '123', cnpj_numero: '456', nome: 'Unidade 1', tipo_unidade_id: 1,
                             codigo_cnes: '1234567', status: 'ativa')
    end
    let(:health_unit2) do
      double('UnidadeSaude', id: 2, cpf_numero: '789', cnpj_numero: '012', nome: 'Unidade 2', tipo_unidade_id: 2,
                             codigo_cnes: '1234567', status: 'inativa')
    end
    let(:unidades_saude) { [health_unit1, health_unit2] }
    let(:paginated_unidades_saude) do
      double('PaginatedUnidadeSaudes', total_pages: 1, total_count: 2, current_page: 1, to_a: unidades_saude)
    end

    before do
      allow(UnidadeSaude).to receive_messages(all: UnidadeSaude, where: UnidadeSaude, public_send: UnidadeSaude,
                                              page: paginated_unidades_saude)
      allow(paginated_unidades_saude).to receive(:per).and_return(paginated_unidades_saude)
    end

    context 'with situacao filter' do
      let(:params) { { situacao: 'ativa', page: 1, per_page: 10 } }

      it 'filters by situacao' do
        service = described_class.new(params)
        result = service.call.data

        expect(result[:unidades_saude].to_a).to eq(unidades_saude)
        expect(result[:total_pages]).to eq(1)
        expect(result[:total_count]).to eq(2)
        expect(result[:current_page]).to eq(1)
      end
    end

    context 'with term filter' do
      let(:params) { { term: '123', page: 1, per_page: 10 } }

      it 'filters by term' do
        service = described_class.new(params)
        result = service.call.data

        expect(result[:unidades_saude].to_a).to eq(unidades_saude)
        expect(result[:total_pages]).to eq(1)
        expect(result[:total_count]).to eq(2)
        expect(result[:current_page]).to eq(1)
      end
    end

    context 'with pagination' do
      let(:params) { { page: 1, per_page: 10 } }

      it 'paginates results' do
        service = described_class.new(params)
        result = service.call.data

        expect(result[:unidades_saude].to_a).to eq(unidades_saude)
        expect(result[:total_pages]).to eq(1)
        expect(result[:total_count]).to eq(2)
        expect(result[:current_page]).to eq(1)
      end
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles
end
