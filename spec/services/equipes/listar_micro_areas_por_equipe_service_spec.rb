# frozen_string_literal: true

RSpec.describe Equipes::ListarMicroAreasPorEquipeService, type: :service do
  let(:equipe_id) { 1 }
  let(:params) { { term: 'Micro' } }
  let(:micro_area_1) { instance_double(MicroArea, nome: 'MicroÁrea 1', codigo: 101) }
  let(:micro_area_2) { instance_double(MicroArea, nome: 'MicroÁrea 2', codigo: 102) }

  describe '#call' do
    context 'when the search is successful' do
      before do
        allow(MicroAreaRepository).to receive(:search_by_equipe).with(equipe_id, params)
          .and_return([micro_area_1, micro_area_2])
      end

      it 'returns success with micro_areas' do
        result = described_class.new(equipe_id, params).call

        expect(result).to be_success
        expect(result.data).to contain_exactly(micro_area_1, micro_area_2)
      end
    end

    context 'when an error occurs' do
      before do
        allow(MicroAreaRepository).to receive(:search_by_equipe).with(equipe_id, params)
          .and_raise(StandardError, 'Something went wrong')
      end

      it 'returns failure with the error message' do
        result = described_class.new(equipe_id, params).call

        expect(result).to be_failure
        expect(result.error).to eq('Something went wrong')
      end
    end
  end
end
