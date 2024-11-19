# frozen_string_literal: true

RSpec.describe Nacionalidades::ListarService do
  describe '.call' do
    subject { described_class.call }

    context 'when there are nacionalidades' do
      let!(:nacionalidade) { create(:nacionalidade) }

      it 'returns a success object with the nacionalidades' do
        result = subject
        expect(result).to be_a_success
        expect(result.data).to eq([nacionalidade])
      end
    end

    context 'when something goes wrong' do
      before do
        allow(NacionalidadeRepository).to receive(:all).and_raise(StandardError.new('error'))
      end

      it 'returns a failure object with the error message' do
        result = subject
        expect(result).to be_a_failure
        expect(result.error).to eq('error')
      end
    end
  end
end
