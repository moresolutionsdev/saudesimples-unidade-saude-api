# frozen_string_literal: true

RSpec.describe AuditsSerializer do
  describe '#render_as_hash' do
    let!(:usuario) { create(:usuario) }
    let!(:audit) { create(:audit) }

    before do
      audit.update!(user_id: usuario.id, user_type: 'Usuario')
    end

    it do
      result = described_class.render_as_hash(audit)
      expect(result).to eq(
        id: audit.id,
        action: audit.action,
        user_type: audit.user_type,
        user_id: usuario.id,
        audited_changes: audit.audited_changes,
        auditable_id: audit.auditable_id,
        auditable_type: audit.auditable_type,
        comment: audit.comment,
        created_at: audit.created_at,
        associated_id: audit.associated_id,
        associated_type: audit.associated_type,
        username: audit.username,
        remote_address: audit.remote_address,
        request_uuid: audit.request_uuid,
        user: {
          id: usuario.id,
          email: usuario.email
        },
        version: audit.version
      )
    end
  end
end
