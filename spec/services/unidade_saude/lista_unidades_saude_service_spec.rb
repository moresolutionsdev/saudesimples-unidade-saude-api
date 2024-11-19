# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnidadeSaude::ListaUnidadesSaudeService do
  describe '#call' do
    subject(:service) { described_class.new(params) }

    let(:params) { {} }

    context 'quando existem unidades de saude' do
      let!(:unidade_saude1) { create(:unidade_saude, nome: 'Hospital A') }
      let!(:unidade_saude2) { create(:unidade_saude, nome: 'Posto de Saúde B') }

      context 'sem especificar ordenacao' do
        it 'retorna listagem padrao' do
          result = service.call
          expect(result).to be_success

          unidades_saude = result.data
          expect(result).to be_a(Success)
          expect(unidades_saude).to contain_exactly(unidade_saude1, unidade_saude2)
        end
      end

      context 'especificando ordenacao' do
        let(:params) { { order: 'nome', order_direction: 'desc' } }

        it 'retorna lista ordenada pelo parametro passado' do
          result = service.call
          expect(result).to be_a(Success)

          unidades_saude = result.data
          expect(unidades_saude).to contain_exactly(unidade_saude2, unidade_saude1)
        end
      end
    end

    context 'quando nao existem unidades de saude' do
      it 'retorna uma lista vazia' do
        result = service.call

        unidades_saude = result.data
        expect(result).to be_a(Success)
        expect(unidades_saude).to be_empty
      end
    end

    context 'quando ocorre erro' do
      it 'retorna erro como resultado' do
        allow(UnidadeSaudeRepository).to receive(:ativas).and_raise(StandardError.new('Database connection error'))

        result = service.call
        expect(result).to be_failure
        expect(result.error).to be_a(StandardError)
        expect(result.error.message).to eq('Database connection error')
      end
    end
  end
end
