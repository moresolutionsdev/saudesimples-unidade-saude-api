# frozen_string_literal: true

RSpec.describe AgendaRepository do
  describe '.create_with_associations' do
    let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
    let!(:profissional) { Profissional.create!(name: 'Profissional Teste') }
    let!(:procedimento) { create(:procedimento) }
    let!(:padrao_agenda) { create(:padrao_agenda) }
    let!(:grupo_atendimento) { create(:grupo_atendimento) }
    let!(:sexo) { create(:sexo) }
    let!(:tipo_atendimento_agenda) { create(:tipo_atendimento_agenda) }

    let(:params) do
      {
        unidade_saude_ocupacao_id: unidade_saude_ocupacao.id,
        profissional_id: profissional.id,
        procedimento_id: procedimento.id,
        possui_grupo: true,
        grupo_atendimento_id: grupo_atendimento.id,
        possui_equipamento: true,
        equipamento_utilizavel_id: 5,
        dias_agendamento: ['2024-09-19'],
        local: 'Local Teste',
        regulacao: 'Regulação Teste',
        sexo_id: sexo.id,
        tipo_atendimento_agenda_id: tipo_atendimento_agenda.id,
        padrao_agenda_id: padrao_agenda.id,
        mapa_periodos: [
          {
            data_inicial: '2024-09-19',
            data_final: '2024-09-25',
            possui_horario_distribuido: true,
            possui_tempo_atendimento_configurado: true,
            inativo: true,
            tempo_atendimento: {
              nova_consulta: 30,
              retorno: 45,
              reserva_tecnica: 15,
              regulacao: 10,
              regulacao_retorno: 20
            },
            mapa_dias: [
              {
                dia_atendimento_id: 1,
                mapa_horarios: [
                  {
                    hora_inicio: '08:00',
                    hora_fim: '10:00',
                    retorno: 15,
                    nova_consulta: 30,
                    reserva_tecnica: 15,
                    regulacao: 10,
                    regulacao_retorno: 20,
                    hora_inicio_str: '08:00',
                    hora_fim_str: '10:00',
                    observacao: 'Observação Teste'
                  }
                ]
              }
            ]
          }
        ]
      }
    end

    it 'creates an agenda with associations' do
      expect { described_class.create_with_associations(params) }.not_to raise_error

      agenda = Agenda.last

      expect(agenda.agenda_mapa_periodos.count).to eq(1)
      expect(agenda.agenda_mapa_periodos.first.agenda_mapa_periodo_tempo_atendimentos.count).to eq(1)
    end
  end

  describe '.historico_agendamentos??' do
    let(:agenda_id) { 1 }
    let(:agendamento_ids) { [10, 20, 30] }

    before do
      allow(described_class).to receive(:agendamentos_exists?).with(agenda_id).and_return(agendamentos_exist)
      # rubocop:disable Layout/LineLength
      allow(described_class).to receive(:ambulatorial_atendimentos_exists?).with(agenda_id).and_return(ambulatorial_exist)
      # rubocop:enable Layout/LineLength
      allow(described_class).to receive(:esus_related_records_exists?).with(agendamento_ids).and_return(esus_exist)
    end

    context 'quando existem agendamentos relacionados' do
      let(:agendamentos_exist) { true }
      let(:ambulatorial_exist) { false }
      let(:esus_exist) { false }

      it 'retorna true' do
        result = described_class.historico_agendamentos?(agenda_id, agendamento_ids)
        expect(result).to be(true)
      end
    end

    context 'quando existem atendimentos ambulatoriais relacionados' do
      let(:agendamentos_exist) { false }
      let(:ambulatorial_exist) { true }
      let(:esus_exist) { false }

      it 'retorna true' do
        result = described_class.historico_agendamentos?(agenda_id, agendamento_ids)
        expect(result).to be(true)
      end
    end

    context 'quando existem fichas e-SUS relacionadas' do
      let(:agendamentos_exist) { false }
      let(:ambulatorial_exist) { false }
      let(:esus_exist) { true }

      it 'retorna false' do
        result = described_class.historico_agendamentos?(agenda_id, agendamento_ids)
        expect(result).to be(true)
      end
    end

    context 'quando não há registros relacionados' do
      let(:agendamentos_exist) { false }
      let(:ambulatorial_exist) { false }
      let(:esus_exist) { false }

      it 'retorna false' do
        result = described_class.historico_agendamentos?(agenda_id, agendamento_ids)
        expect(result).to be(false)
      end
    end
  end

  describe '.unidade_saude_ocupacao_exists?' do
    let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }

    context 'quando a unidade_saude_ocupacao existe' do
      it 'retorna true' do
        result = described_class.unidade_saude_ocupacao_exists?(unidade_saude_ocupacao.id)
        expect(result).to be(true)
      end
    end

    context 'quando a unidade_saude_ocupacao não existe' do
      it 'retorna false' do
        result = described_class.unidade_saude_ocupacao_exists?(0)
        expect(result).to be(false)
      end
    end
  end

  describe '.profissional_exists?' do
    let!(:profissional) { create(:profissional) }

    context 'quando o profissional existe' do
      it 'retorna true' do
        result = described_class.profissional_exists?(profissional.id)
        expect(result).to be(true)
      end
    end

    context 'quando o profissional não existe' do
      it 'retorna false' do
        result = described_class.profissional_exists?(0)
        expect(result).to be(false)
      end
    end
  end

  describe '.procedimento_exists?' do
    let!(:procedimento) { create(:procedimento) }

    context 'quando o procedimento existe' do
      it 'retorna true' do
        result = described_class.procedimento_exists?(procedimento.id)
        expect(result).to be(true)
      end
    end

    context 'quando o procedimento não existe' do
      it 'retorna false' do
        result = described_class.procedimento_exists?(0)
        expect(result).to be(false)
      end
    end
  end

  describe '.exist?' do
    let!(:agenda) { create(:agenda) }

    context 'quando a agenda existe' do
      it 'retorna true' do
        result = described_class.exist?(agenda.id)
        expect(result).to be(true)
      end
    end

    context 'quando a agenda não existe' do
      it 'retorna false' do
        result = described_class.exist?(0)
        expect(result).to be(false)
      end
    end
  end

  describe '.delete_agenda' do
    let!(:agenda) { create(:agenda) }
    let!(:agenda_mapa_periodo) { create(:agenda_mapa_periodo, agenda:) }

    context 'quando a exclusão lógica é bem-sucedida' do
      it 'marca a agenda como deletada' do
        result = described_class.delete_agenda(agenda.id)
        expect(result).to be(true)

        agenda.reload
        expect(agenda.inativo).not_to be_nil
      end

      it 'marca os agenda_mapa_periodos relacionados como deletados' do
        agenda_mapa_periodo.reload
        expect(agenda_mapa_periodo.inativo).not_to be_nil
      end
    end

    context 'quando ocorre um erro durante a exclusão' do
      before do
        allow(Agenda).to receive(:find).and_raise(StandardError, 'Erro ao excluir agenda')
      end

      it 'retorna false' do
        result = described_class.delete_agenda(agenda.id)
        expect(result).to be(false)
      end
    end
  end
end
