# frozen_string_literal: true

RSpec.describe SyncEquipesWithCNESJob do
  subject { described_class.perform_now(page) }

  let(:page) { 1 }
  let(:equipes) do
    [
      {
        tipo_equipe_id: 76,
        unidade_saude_id: 68,
        area: 2,
        codigo: 2_056_429,
        data_desativacao: nil,
        data_ativacao: '2024-07-08',
        nome_referencia: 'EQ03 EAP NOVA ARUJA',
        created_at: Time.current,
        updated_at: Time.current
      },
      {
        tipo_equipe_id: 76,
        unidade_saude_id: 69,
        area: 12,
        codigo: 1_471_872,
        data_desativacao: nil,
        data_ativacao: '2024-07-08',
        nome_referencia: 'EQ02 EAP PILAR',
        created_at: Time.current,
        updated_at: Time.current
      }
    ]
  end

  before do
    allow(EquipeRepository).to receive(:list_from_cnes).with(page:).and_return(equipes)
    allow(Equipes::UpsertService).to receive(:call)
  end

  context 'when there are equipes' do
    it 'calls the upsert service with the fetched equipes' do
      subject

      expect(Equipes::UpsertService).to have_received(:call).with(equipes)
    end

    it 'schedules the next job with incremented page' do
      expect { subject }.to have_enqueued_job(described_class).with(page + 1)
    end
  end

  context 'when there are no equipes' do
    let(:equipes) { [] }

    it 'does not call the upsert service' do
      subject
      expect(Equipes::UpsertService).not_to have_received(:call)
    end

    it 'does not schedule the next job' do
      expect { subject }.not_to have_enqueued_job(described_class)
    end
  end
end
