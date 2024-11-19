# frozen_string_literal: true

RSpec.describe AgendaSerializer do
  let(:tipo_equipamento) { build(:tipo_equipamento, id: 2, nome: 'Tipo A', codigo: '123') }
  let(:equipamento) do
    build(:equipamento, id: 1, nome: 'Equipamento X', codigo: '456', tipo_equipamento:)
  end
  let(:equipamento_utilizavel) do
    build(:equipamento_utilizavel,
          id: 3,
          nome: 'Equipamento Y',
          fabricante: 'Fabricante Z',
          numero_serie: '1234',
          equipamento:,
          tipo_equipamento:)
  end
  let(:unidade_saude_ocupacao) do
    build(:unidade_saude_ocupacao,
          id: 4,
          unidade_saude: build(:unidade_saude, id: 5, nome: 'Unidade Saude 1'),
          ocupacao: build(:ocupacao, id: 6, nome: 'Ocupacao 1', codigo: '1111', saude: false))
  end
  let(:padrao_agenda) { build(:padrao_agenda, id: 7, nome: 'Agenda Padrao') }
  let(:procedimento) { build(:procedimento, id: 8, nome: 'Procedimento Padrão', codigo: '99') }
  let(:profissional) { build(:profissional, id: 9, nome: 'Profissional A', codigo: '123') }
  let(:agenda) do
    build(:agenda,
          id: 1,
          unidade_saude_ocupacao:,
          padrao_agenda:,
          procedimento:,
          equipamento_utilizavel:,
          profissional:,
          local: true,
          regulacao: false)
  end

  describe '#render_as_hash' do
    it 'serializes the agenda correctly' do
      result = described_class.render_as_hash(agenda, view: :listagem_agenda)

      expect(result).to match(
        id: 1,
        possui_equipamento: agenda.possui_equipamento,
        local: true,
        regulacao: false,
        unidade_saude_ocupacao: {
          id: 4,
          unidade_saude: {
            id: 5,
            nome: 'Unidade Saude 1'
          },
          ocupacao: {
            id: 6,
            nome: 'Ocupacao 1',
            codigo: '1111',
            saude: false
          }
        },
        padrao_agenda: {
          id: 7,
          nome: 'Agenda Padrao'
        },
        procedimento: {
          id: 8,
          nome: 'Procedimento Padrão',
          codigo: '99'
        },
        equipamento_utilizavel: {
          id: 3,
          nome: 'Equipamento Y',
          fabricante: 'Fabricante Z',
          numero_serie: '1234',
          equipamento: {
            id: 1,
            codigo: '456',
            nome: 'Equipamento X',
            tipo_equipamento: {
              id: 2,
              nome: 'Tipo A',
              codigo: '123'
            }
          },
          tipo_equipamento: {
            id: 2,
            nome: 'Tipo A',
            codigo: '123'
          }
        },
        profissional: {
          id: 9,
          codigo: '123',
          nome: 'Profissional A'
        }
      )
    end
  end

  describe 'when there is an error during serialization' do
    it 'handles the error gracefully' do
      allow(agenda).to receive(:unidade_saude_ocupacao).and_raise(StandardError, 'Erro durante a serialização')

      expect do
        described_class.render_as_hash(agenda, view: :listagem_agenda)
      end.to raise_error(StandardError, 'Erro durante a serialização')
    end
  end

  describe 'render with normal view' do
    it 'serializes the agenda correctly' do
      result = described_class.render_as_hash(agenda, view: :normal)

      expect(result).to match(
        id: 1,
        local: true,
        regulacao: false,
        inativo: false,
        padrao_agenda: padrao_agenda.nome,
        situacao: 'Ativo',
        unidade_saude: unidade_saude_ocupacao.unidade_saude.nome,
        data_final: nil,
        data_inicial: nil,
        especialidade: {
          id: unidade_saude_ocupacao.id,
          nome: unidade_saude_ocupacao.ocupacao.nome
        },
        procedimento: {
          id: 8,
          nome: 'Procedimento Padrão'
        },
        profissional: {
          id: 9,
          nome: 'Profissional A',
          codigo_cns: profissional.codigo_cns,
          cpf_numero: profissional.cpf_numero,
          matricula: profissional.matricula
        },
        acoes: {
          editar: true,
          excluir: true,
          bloquear: true
        }
      )
    end
  end
end
