# frozen_string_literal: true

RSpec.describe UnidadeSaude::Profissional::VinculaProfissionalUnidadeSaudeService, type: :service do
  let(:mock_de_permissoes_validas) { { vinculo_de_profissional: { create: true } } }
  let(:mock_de_permissoes_invalidas) { { vinculo_de_profissional: { create: false } } }
  let(:vinculo_profissional_service) { described_class }
  let(:vinculo_profissional_validade) { UnidadeSaude::Profissional::VinculaProfissionalUnidadeSaudeValidadeService }
  let(:profissional_unidade_saude) { create(:profissional_unidade_saude) }
  let(:params) do
    unidade_saude = create(:unidade_saude)
    create(:tipo_cadastro_profissional)
    create(:tipo_profissional)
    profissional = create(:profissional)
    ocupacao = create(:ocupacao)

    { unidade_saude_id: unidade_saude.id, profissional_id: profissional.id, ocupacao_id: ocupacao.id }
  end

  let(:service) { vinculo_profissional_service.new(params) }

  describe '#call' do
    context 'quando o vinculo é realizado com sucesso' do
      before do
        allow_any_instance_of(vinculo_profissional_validade).to receive(:call).and_return(true)
      end

      it 'cria um novo vinculo de profissional com unidade de saúde' do
        expect { service.call }.to change(ProfissionalUnidadeSaude, :count).by(1)
      end

      it 'retorna um objeto de sucesso com os dados do vinculo' do
        expect(service.call).to be_a(Success)
        expect(service.call.data).to include(:id, :ocupacao, :profissional)
      end
    end

    context 'quando o usuário não tem permissão para vincular o profissional' do
      before do
        allow_any_instance_of(vinculo_profissional_validade)
          .to receive(:tem_permissao_para_vincular_profissional?).and_return(false)

        allow(Rails.logger).to receive(:error).at_least(:once)
      end

      it 'levanta um erro de permissão' do
        expect(service.call).to be_a(Failure)
        expect(Rails.logger).to have_received(:error)
          .with('Nâo tem permissão para vincular profissional com a unidade de saúde').once
      end
    end

    context 'quando a unidade de saúde não existe' do
      before do
        allow_any_instance_of(vinculo_profissional_validade)
          .to receive(:tem_permissao_para_vincular_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_unidade_saude?).and_return(false)

        allow(Rails.logger).to receive(:error).at_least(:once)
      end

      it 'levanta um erro de permissão' do
        expect(service.call).to be_a(Failure)
        expect(Rails.logger).to have_received(:error).with(/Nâo foi possivel encontrar a unidade de saúde com id/).once
      end
    end

    context 'quando o profissional não existe' do
      before do
        allow_any_instance_of(vinculo_profissional_validade)
          .to receive(:tem_permissao_para_vincular_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_unidade_saude?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_profissional?).and_return(false)

        allow(Rails.logger).to receive(:error).at_least(:once)
      end

      it 'levanta um erro de permissão' do
        expect(service.call).to be_a(Failure)
        expect(Rails.logger).to have_received(:error).with(/Nâo foi possivel encontrar a profissional com id/).once
      end
    end

    context 'quando o vinculo já existe' do
      before do
        allow_any_instance_of(vinculo_profissional_validade)
          .to receive(:tem_permissao_para_vincular_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_unidade_saude?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:vinculo_existente?).and_return(true)

        allow(Rails.logger).to receive(:error).at_least(:once)
      end

      it 'levanta um erro de permissão' do
        expect(service.call).to be_a(Failure)
        expect(Rails.logger).to have_received(:error).with('Profissional já vinculado').once
      end
    end

    context 'quando a ocupação não existe' do
      before do
        allow_any_instance_of(vinculo_profissional_validade)
          .to receive(:tem_permissao_para_vincular_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_unidade_saude?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_profissional?).and_return(true)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:vinculo_existente?).and_return(false)
        allow_any_instance_of(vinculo_profissional_validade).to receive(:existe_ocupacao?).and_return(false)

        allow(Rails.logger).to receive(:error).at_least(:once)
      end

      it 'levanta um erro de permissão' do
        expect(service.call).to be_a(Failure)
        expect(Rails.logger).to have_received(:error).with(/Nâo foi possivel encontrar a ocupação com id/).once
      end
    end
  end
end
