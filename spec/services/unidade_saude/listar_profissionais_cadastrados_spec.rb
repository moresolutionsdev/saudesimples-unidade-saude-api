# frozen_string_literal: true

RSpec.describe UnidadeSaude::ListarProfissionaisCadastrados, type: :service do
  let(:unidade_saude) { create(:unidade_saude) }
  let(:page) { 1 }
  let(:per) { 10 }
  let(:search_params) { { page:, per: } }

  describe '#call' do
    subject { described_class.call(unidade_saude:, search_params:) }

    context 'when there are no profissionais cadastrados' do
      let(:relation) { double('ActiveRecord::Relation') }

      before do
        allow(unidade_saude).to receive(:profissionais_cadastrados).and_return(relation)
        allow(relation).to receive_messages(joins: relation, order: relation, page: relation, per: [])
      end

      it 'returns a Success with an empty array' do
        expect(subject).to be_a(Success)
        expect(subject.data).to eq([])
      end
    end

    context 'when there are profissionais cadastrados' do
      let!(:profissionais) { create_list(:profissional_unidade_saude, 3, unidade_saude:) }

      it 'returns a Success with the profissionais' do
        expect(subject).to be_a(Success)
        expect(subject.data).to match_array(profissionais)
      end
    end

    context 'when search_params includes a nome' do
      let(:search_params) { { nome: 'jo', page:, per: } }
      let(:profissional) { create(:profissional, nome: 'joao') }
      let!(:filtered_profissionais) { create(:profissional_unidade_saude, profissional:, unidade_saude:) }

      it 'returns a Success with the filtered profissionais' do
        expect(subject).to be_a(Success)
        expect(subject.data).to match_array(filtered_profissionais)
      end
    end

    context 'when search_params includes an ocupacao_nome' do
      let(:search_params) { { ocupacao_nome: 'me', page:, per: } }
      let(:ocupacao) { create(:ocupacao, nome: 'medico') }
      let!(:filtered_profissionais) { create(:profissional_unidade_saude, ocupacao:, unidade_saude:) }

      it 'returns a Success with the filtered profissionais' do
        expect(subject).to be_a(Success)
        expect(subject.data).to match_array(filtered_profissionais)
      end
    end

    context 'when an error occurs' do
      before do
        allow(unidade_saude).to receive(:profissionais_cadastrados).and_raise(StandardError)
      end

      it 'returns a Failure' do
        expect(subject).to be_a(Failure)
      end
    end
  end
end
