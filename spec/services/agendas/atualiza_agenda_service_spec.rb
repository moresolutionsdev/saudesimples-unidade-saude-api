# frozen_string_literal: true

RSpec.describe Agendas::AtualizaAgendaService do
  subject(:service) { described_class.call(id:, params:) }

  let(:agenda) { create(:agenda, inativo: false) }
  let(:id) { agenda.id }
  let(:params) { { inativo: true } }

  before do
    Faker::UniqueGenerator.clear
  end

  context 'when given an agenda' do
    context 'when update is successful' do
      before { service }

      it 'update based on params' do
        expect(agenda.reload.inativo).to be_truthy
      end

      it { is_expected.to be_a(Success) }
    end

    context 'when params is empty' do
      let(:empty_params) { {} }

      it 'return 200' do
        result = described_class.new(id: agenda.id, params: empty_params).call
        expect(result).to be_a(Success)
      end
    end

    context 'when something went wrong' do
      let(:wrong_id) { -1 }

      it 'do not update resource' do
        described_class.new(id: wrong_id, params:).call
        expect(agenda.reload.inativo).to be_falsey
      end

      it 'is_expected.to be_a(Failure)' do
        result = described_class.new(id: wrong_id, params:).call
        expect(result).to be_a(Failure)
      end

      describe 'validations' do
        let!(:agenda) { create(:agenda, inativo: false, possui_equipamento: false) }
        let!(:unidade_saude_ocupacao) { create(:unidade_saude_ocupacao) }
        let!(:profissional) { create(:profissional) }
        let!(:procedimento) { create(:procedimento) }
        let!(:equipamento_utilizavel) { create(:equipamento_utilizavel) }
        let!(:padrao_agenda) { create(:padrao_agenda) }

        let(:params) do
          {
            local: false,
            regulacao: true
          }
        end

        context 'when agenda is not found' do
          it 'returns failure' do
            result = described_class.new(id: -1, params: params.clone).call

            expect(result).to be_a(Failure)
            expect(result.error).to include('Agenda não encontrada')
          end
        end

        context 'validating unidade_saude_ocupacao_id' do
          context 'when unidade_saude_ocupacao_id valid' do
            it 'edits it' do
              modified_params = params.clone
              modified_params[:unidade_saude_ocupacao_id] = unidade_saude_ocupacao.id

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Success)
              expect(result.data).to have_attributes(
                unidade_saude_ocupacao_id: unidade_saude_ocupacao.id
              )
            end
          end

          context 'when unidade_saude_ocupacao_id is invalid' do
            it 'being a value that does not exist returns failure' do
              modified_params = params.clone
              modified_params[:unidade_saude_ocupacao_id] = 22

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include('Especialidade inválida')
            end
          end
        end

        context 'validating profissional_id' do
          context 'when profissional_id valid' do
            it 'edits it' do
              modified_params = params.clone
              modified_params[:profissional_id] = profissional.id

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Success)
              expect(result.data).to have_attributes(
                profissional_id: profissional.id
              )
            end
          end

          context 'when profissional_id does not exist' do
            it 'returns failure' do
              modified_params = params.clone
              modified_params[:profissional_id] = -1

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include('Profissional inválido')
            end
          end
        end

        context 'validating procedimento_id' do
          context 'when procedimento_id valid' do
            it 'edits it' do
              modified_params = params.clone
              modified_params[:procedimento_id] = procedimento.id

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Success)
              expect(result.data).to have_attributes(
                procedimento_id: procedimento.id
              )
            end
          end

          context 'when procedimento_id does not exist' do
            it 'returns failure' do
              modified_params = params.clone
              modified_params[:procedimento_id] = -1

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include('Procedimento inválido')
            end
          end
        end

        context 'validating padrao_agenda_id' do
          context 'when padrao_agenda_id valid' do
            it 'edits it' do
              modified_params = params.clone
              modified_params[:padrao_agenda_id] = padrao_agenda.id

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Success)
              expect(result.data).to have_attributes(
                padrao_agenda_id: padrao_agenda.id
              )
            end
          end

          context 'when padrao_agenda_id does not exist' do
            it 'returns failure' do
              modified_params = params.clone
              modified_params[:padrao_agenda_id] = -1

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include('Padrão de Agenda inválido')
            end
          end
        end

        context 'validating equipamento_utilizavel_id' do
          context 'when equipamento_utilizavel_id valid' do
            it 'edits it' do
              modified_params = params.clone
              modified_params[:possui_equipamento] = true
              modified_params[:equipamento_utilizavel_id] = equipamento_utilizavel.id

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Success)
              expect(result.data).to have_attributes(
                equipamento_utilizavel_id: equipamento_utilizavel.id
              )
            end
          end

          it 'when it is invalid, it should return error' do
            modified_params = params.clone
            modified_params[:possui_equipamento] = true
            modified_params[:equipamento_utilizavel_id] = -1

            result = described_class.new(id: agenda.id, params: modified_params).call

            expect(result).to be_a(Failure)
            expect(result.error).to include('Equipamento utilizável inválido')
          end

          it 'when it is provided but possui_equipamento is not provided, it should return error' do
            modified_params = params.clone
            modified_params[:equipamento_utilizavel_id] = equipamento_utilizavel.id

            result = described_class.new(id: agenda.id, params: modified_params).call

            expect(result).to be_a(Failure)
            expect(result.error).to include(
              'Não é possível especificar um equipamento utilizável se não informar se possui um equipamento'
            )
          end

          it 'when it is not provided but possui_equipamento is provided, it should return error' do
            modified_params = params.clone
            modified_params[:possui_equipamento] = true

            result = described_class.new(id: agenda.id, params: modified_params).call

            expect(result).to be_a(Failure)
            expect(result.error).to include(
              'Obrigatório o envio de um equipamento utilizável, se possui um equipamento'
            )
          end

          context 'when multiple equipment-related errors occur' do
            it 'returns all equipment-related error messages' do
              modified_params = params.clone
              modified_params[:equipamento_utilizavel_id] = -1
              modified_params[:padrao_agenda_id] = -1

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include(
                'Não é possível especificar um equipamento utilizável se não informar se possui um equipamento',
                'Padrão de Agenda inválido'
              )
              expect(result.error).not_to include('Equipamento utilizável inválido')
            end

            it 'returns error when possui_equipamento is true but equipamento_utilizavel_id is missing' do
              modified_params = params.clone
              modified_params[:possui_equipamento] = true
              modified_params[:equipamento_utilizavel_id] = nil

              result = described_class.new(id: agenda.id, params: modified_params).call

              expect(result).to be_a(Failure)
              expect(result.error).to include(
                'Obrigatório o envio de um equipamento utilizável, se possui um equipamento'
              )
            end
          end
        end

        context 'when multiple errors occur' do
          it 'returns all error messages' do
            modified_params = params.clone
            modified_params[:profissional_id] = -1
            modified_params[:procedimento_id] = -1
            modified_params[:unidade_saude_ocupacao_id] = -1

            result = described_class.new(id: agenda.id, params: modified_params).call

            expect(result).to be_a(Failure)
            expect(result.error).to include(
              'Profissional inválido',
              'Procedimento inválido',
              'Especialidade inválida'
            )
          end
        end

        context 'when all params are valid' do
          it 'successfully updates the agenda' do
            modified_params = params.clone
            modified_params[:unidade_saude_ocupacao_id] = unidade_saude_ocupacao.id
            modified_params[:profissional_id] = profissional.id
            modified_params[:procedimento_id] = procedimento.id
            modified_params[:padrao_agenda_id] = padrao_agenda.id
            modified_params[:possui_equipamento] = true
            modified_params[:equipamento_utilizavel_id] = equipamento_utilizavel.id

            result = described_class.new(id: agenda.id, params: modified_params).call

            expect(result).to be_a(Success)

            expect(result.data).to have_attributes(
              unidade_saude_ocupacao_id: unidade_saude_ocupacao.id,
              profissional_id: profissional.id,
              procedimento_id: procedimento.id,
              equipamento_utilizavel_id: equipamento_utilizavel.id,
              padrao_agenda_id: padrao_agenda.id,
              possui_equipamento: true,
              local: false,
              regulacao: true
            )
          end
        end

        context 'when update fails' do
          before do
            allow_any_instance_of(Agenda).to receive(:update!).and_raise(StandardError, 'Erro ao atualizar agenda')
          end

          it 'returns failure' do
            result = described_class.new(id: agenda.id, params: params.clone).call

            expect(result).to be_a(Failure)
            expect(result.error).to eq('Erro ao atualizar agenda')
          end
        end
      end
    end
  end
end
