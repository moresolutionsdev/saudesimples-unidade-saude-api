# frozen_string_literal: true

# spec/atendimento_repository_spec.rb

require 'rails_helper'

RSpec.describe AtendimentoRepository, type: :model do
  describe '.upsert_dia_atendimento' do
    let(:unidade_saude) { create(:unidade_saude) }
    let(:dia_atendimento) { create(:dia_atendimento) }

    context 'quando o horário não existe' do
      it 'cria um novo horário' do
        expect do
          described_class.upsert_dia_atendimento(
            unidade_saude.id,
            dia_atendimento_id: dia_atendimento.id,
            horario_inicio: '08:00',
            horario_encerramento: '18:00'
          )
        end.to change(UnidadeSaudeHorario, :count).by(1)
      end
    end

    context 'quando o horário já existe' do
      let!(:horario_existente) do
        create(:unidade_saude_horario, unidade_saude:, dia_atendimento:)
      end

      it 'atualiza o horário existente' do
        expect do
          described_class.upsert_dia_atendimento(
            unidade_saude.id,
            dia_atendimento_id: dia_atendimento.id,
            horario_inicio: '09:00',
            horario_encerramento: '17:00'
          )
        end.not_to change(UnidadeSaudeHorario, :count)

        horario_existente.reload
        expect(horario_existente.hora_inicio.strftime('%H:%M')).to eq('09:00')
        expect(horario_existente.hora_fim.strftime('%H:%M')).to eq('17:00')
      end
    end

    context 'quando os dados são inválidos' do
      it 'lança uma exceção ActiveRecord::RecordInvalid' do
        expect do
          described_class.upsert_dia_atendimento(
            unidade_saude.id,
            dia_atendimento_id: nil, # Valor inválido
            horario_inicio: '08:00',
            horario_encerramento: '18:00'
          )
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.find_dia_atendimento_by_nome' do
    let!(:dia_atendimento) { create(:dia_atendimento, nome: 'Segunda-Feira') }

    it 'encontra o dia de atendimento pelo nome' do
      result = described_class.find_dia_atendimento_by_nome('Segunda-Feira')
      expect(result).to eq(dia_atendimento)
    end

    it 'encontra o dia de atendimento pelo nome com caracteres especiais' do
      result = described_class.find_dia_atendimento_by_nome('Segunda-Feira!!!')
      expect(result).to eq(dia_atendimento)
    end

    it 'retorna nil se o dia de atendimento não for encontrado' do
      result = described_class.find_dia_atendimento_by_nome('Domingo')
      expect(result).to be_nil
    end
  end
end
