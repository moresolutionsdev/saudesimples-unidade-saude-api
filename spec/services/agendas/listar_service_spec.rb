# frozen_string_literal: true

RSpec.describe Agendas::ListarService, type: :service do
  before do
    # Limpa o cache de valores únicos pra resolver o erro Retry limit exceeded for number
    Faker::UniqueGenerator.clear
  end

  let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
  let!(:unidade_saude_ocupacao_2) { create(:unidade_saude_ocupacao) }
  let(:profissional) { create(:profissional, nome: 'a') }
  let(:profissional_2) { create(:profissional, nome: 'b') }
  let(:profissional_3) { create(:profissional, nome: 'c') }
  let!(:agenda_1) do
    create(:agenda, unidade_saude_ocupacao_id: unidade_saude_ocupacao.id, profissional:, regulacao: true,
                    inativo: false, local: false)
  end
  let!(:agenda_2) do
    create(:agenda, unidade_saude_ocupacao_id: unidade_saude_ocupacao.id, profissional: profissional_2,
                    regulacao: false, inativo: true, local: true)
  end
  let!(:agenda_3) do
    create(:agenda, unidade_saude_ocupacao_id: unidade_saude_ocupacao_2.id, profissional: profissional_3,
                    regulacao: false, inativo: true)
  end

  let!(:agenda_mapa_periodo_1) do
    create(:agenda_mapa_periodo, agenda_id: agenda_1.id, data_inicial: '2024-09-01', data_final: '2024-09-10')
  end

  let!(:agenda_mapa_periodo_2) do
    create(:agenda_mapa_periodo, agenda_id: agenda_2.id, data_inicial: '2024-09-11', data_final: '2024-09-20')
  end

  let!(:agenda_mapa_periodo_3) do
    create(:agenda_mapa_periodo, agenda_id: agenda_3.id, data_inicial: '2024-09-11', data_final: '2024-09-20')
  end

  describe '#call' do
    subject { described_class.call(params) }

    context 'when no filters' do
      let(:params) { {} }

      it 'return paginated agendas' do
        expect(subject).to be_success
      end
    end

    context 'when filtering for start and final date' do
      let(:params) { { data_inicial: '2024-09-01', data_final: '2024-09-10' } }

      it 'return success' do
        expect(subject).to be_success
      end

      it 'return agendas given period' do
        expect(subject.data).to include(agenda_1)
        expect(subject.data).not_to include(agenda_2)
        expect(subject.data).not_to include(agenda_3)
      end
    end

    context 'when filtering for unidade_saude_id' do
      let(:params) { { unidade_saude_id: unidade_saude_ocupacao.unidade_saude_id } }

      it 'return success' do
        expect(subject).to be_success
      end

      it 'return only agenda with unidade_saude_id' do
        expect(subject.data.size).to eq(2)
      end
    end

    context 'when filtering for inativo' do
      context "when 'todas' is selected" do
        let(:params) { { inativo: nil } }

        it 'return all' do
          expect(subject.data.size).to eq(3)
        end
      end

      context "when 'ativas' is selected" do
        let(:params) { { inativo: true } }

        it 'return only ativas' do
          expect(subject.data).to include(agenda_2)
          expect(subject.data).not_to include(agenda_1)
        end
      end

      context "when 'inativas' is selected" do
        let(:params) { { inativo: false } }

        it 'return only ativas' do
          expect(subject.data).to include(agenda_1)
          expect(subject.data).not_to include(agenda_2)
        end
      end
    end

    context 'when has pagination params' do
      let(:params) { { page: 1, per_page: 1 } }

      it 'return collection paginated' do
        expect(subject.data.count).to eq(1)
      end
    end

    context 'when ordering by profissional.nome' do
      let(:params) { { order: 'profissional.nome', order_direction: 'desc' } }

      it 'order by profissionais' do
        expect(subject.data.first.profissional).to eq(profissional_3)
      end
    end

    context 'when ordering by inativo' do
      context 'when order direction asc' do
        let(:params) { { order: 'inativo', order_direction: 'asc' } }

        it 'order by situacao' do
          expect(subject.data.first).to eq(agenda_1)
        end
      end

      context 'when order diretcion desc' do
        let(:params) { { order: 'inativo', order_direction: 'desc' } }

        it 'order by situacao' do
          expect(subject.data.first).to eq(agenda_2)
        end
      end
    end

    context 'when filtering for tipo agenda' do
      context 'when regulacao' do
        let(:params) { { regulacao: true } }

        it 'filter by regulacao' do
          expect(subject.data).to include(agenda_1)
          expect(subject.data).not_to include(agenda_2)
        end
      end

      context 'when local' do
        let(:params) { { local: true } }

        it 'filter by local' do
          expect(subject.data).to include(agenda_2)
          expect(subject.data).not_to include(agenda_1)
        end
      end
    end
  end
end
