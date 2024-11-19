# frozen_string_literal: true

RSpec.describe UnidadeSaude::Agendas::BuscarAgendaService, type: :service do
  describe '#call' do
    subject { described_class.call(agenda.id) }

    before do
      # Limpa o cache de valores únicos pra resolver o erro Retry limit exceeded for number
      Faker::UniqueGenerator.clear
    end

    let(:agenda) { create(:agenda) }

    context 'when the agenda exists' do
      it 'retorna o sucesso com dados da agenda' do
        expect(subject).to be_success
        expect(subject.data).to eq(agenda)
      end
    end

    context 'when the agenda does not exist' do
      subject { described_class.call(99) }

      it 'returns an error that it was not possible find agenda with that id' do
        expect(subject).to be_failure
        expect(subject.error).to eq('Não foi possivel encontrar a agenda com id 99')
      end
    end

    describe 'checking associations' do
      subject { described_class.new(agenda.id).call }

      let!(:unidade_saude) { create(:unidade_saude) }
      let!(:ocupacao) { create(:ocupacao) }
      let!(:unidade_saude_ocupacao) do
        create(:unidade_saude_ocupacao, unidade_saude:, ocupacao:)
      end
      let!(:equipamento) { create(:equipamento) }
      let!(:tipo_equipamento) { create(:tipo_equipamento) }
      let!(:equipamento_utilizavel) do
        create(:equipamento_utilizavel, equipamento:, tipo_equipamento:, unidade_saude:)
      end
      let!(:agenda) do
        create(
          :agenda,
          profissional: create(:profissional),
          padrao_agenda: create(:padrao_agenda),
          procedimento: create(:procedimento),
          unidade_saude_ocupacao:,
          equipamento_utilizavel:
        )
      end

      it 'returns the agenda with all associated records included' do
        result = subject

        expect(result).to be_success
        expect(result.data).to eq(agenda)

        expect(result.data.profissional).to eq(agenda.profissional)
        expect(result.data.padrao_agenda).to eq(agenda.padrao_agenda)
        expect(result.data.procedimento).to eq(agenda.procedimento)
        expect(result.data.unidade_saude_ocupacao).to eq(agenda.unidade_saude_ocupacao)
        expect(result.data.equipamento_utilizavel).to eq(agenda.equipamento_utilizavel)
      end
    end
  end
end
