# frozen_string_literal: true

RSpec.describe Audits::BuscarAuditsService do
  describe '#call' do
    let!(:user1) { create(:usuario, email: 'gluz@teste.com') }
    let!(:user2) { create(:usuario, email: 'shanks@akagami.com') }
    let(:params) { { page: 1, per_page: 10 } }

    before do
      last_user = user1
      (1..10).each do |_i|
        audit = create(:audit, audited_changes: [Faker::Internet.email],
                               created_at: Faker::Time.between(from: 2.years.ago, to: 2.months.ago))

        audit.update!(user_id: last_user.id, user_type: 'Usuario')
        last_user = last_user.id == user1.id ? user2 : user1
      end
    end

    it 'return result with required data' do
      service = described_class.new(params)
      result = service.call.data
      expect(result).to all(respond_to(:created_at, :audited_changes, :user_id))
    end

    context 'when pass another page param' do
      let!(:audit) do
        create(:audit, created_at: 10.years.ago, audited_changes: ['changes'])
      end
      let(:params) { { page: 2, per_page: 10, order_direction: 'desc' } }

      before do
        audit.update!(user_id: user2.id)
      end

      it 'returns second page result and includes the correct audit' do
        service = described_class.new(params)
        result = service.call.data

        expect(result.map(&:id)).to include(audit.id)

        sorted_result = result.sort_by(&:created_at).reverse
        expect(result.map(&:created_at)).to eq(sorted_result.map(&:created_at))
      end
    end

    context 'when order direction is default' do
      let!(:audit) do
        create(:audit, created_at: 4.years.ago, audited_changes: ['changes'])
      end

      let(:params) { { page: 1, per_page: 20, order_direction: 'asc' } }

      before do
        audit.update!(user_id: user1.id)
      end

      it 'return result ordered by date asc' do
        service = described_class.new(params)
        result = service.call.data

        expect(result.first.created_at.to_i).to eq(audit.created_at.to_i)
      end
    end

    context 'when order desc is passed' do
      let!(:audit) do
        create(:audit, created_at: Time.zone.now, audited_changes: ['changes'])
      end

      let(:params) { { page: 1, per_page: 20, order_direction: 'desc' } }

      before do
        audit.update!(user_id: user1.id)
      end

      it 'return result ordered by date desc' do
        service = described_class.new(params)
        result = service.call.data

        expect(result.first.created_at.to_i).to eq(audit.created_at.to_i)
      end
    end

    context 'when is filtered by term' do
      let(:params) { { page: 1, per_page: 20, term: 'akagami' } }

      it 'returns only audits with email akagami' do
        service = described_class.new(params)
        result = service.call.data

        expect(result.map { |audit| audit.user.email }.all?('shanks@akagami.com')).to be true
      end
    end
  end
end
