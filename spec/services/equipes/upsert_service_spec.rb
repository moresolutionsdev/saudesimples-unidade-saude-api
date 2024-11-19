# frozen_string_literal: true

RSpec.describe Equipes::UpsertService do
  describe '.call' do
    subject(:run_service) { described_class.call(params) }

    let(:unidade_saude) { create(:unidade_saude) }
    let(:tipo_equipe) { create(:tipo_equipe, codigo: '70') }

    let(:params) do
      [{
        tipo_equipe: tipo_equipe.codigo,
        unidade_saude_id: unidade_saude.id,
        codigo_area: '0201',
        codigo_ine: '0001526189',
        data_desativacao: nil,
        created_at: '2024-06-10T22:58:50.625Z',
        nome_referencia: 'EQUIPE TERESA CRISTINA - VERDE'
      }]
    end

    context 'when the execution is successful' do
      subject(:equipe) { Equipe.first }

      it 'returns a success object with the created equipe' do
        expect(run_service).to be_a_success
      end

      context 'when persisted' do
        before do
          run_service
        end

        it 'return unidade_saude_id' do
          expect(equipe.unidade_saude_id).to eq(params.first[:unidade_saude_id])
        end

        it 'return tipo_equipe' do
          # set the tipo_equipe based on the codigo
          expect(equipe.tipo_equipe_id).to eq(tipo_equipe.id)
        end

        it 'return area' do
          expect(equipe.area).to eq(params.first[:codigo_area].to_i)
        end

        it 'return codigo' do
          expect(equipe.codigo).to eq(params.first[:codigo_ine].to_i)
        end

        it 'return data_desativacao' do
          expect(equipe.data_desativacao).to eq(params.first[:data_desativacao])
        end

        it 'return data_ativacao' do
          expect(equipe.data_ativacao).to eq(params.first[:created_at].to_date)
        end

        it 'return nome_referencia' do
          expect(equipe.nome_referencia).to eq(params.first[:nome_referencia])
        end
      end
    end
  end
end
