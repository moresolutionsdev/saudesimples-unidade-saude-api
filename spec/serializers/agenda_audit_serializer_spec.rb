# frozen_string_literal: true

RSpec.describe AgendaAuditSerializer do
  let!(:agenda) { create(:agenda) }
  let!(:audit) { create(:audit, auditable: agenda) }
  let!(:serialized_audit) { JSON.parse(described_class.render(audit)) }

  describe 'AgendaAuditSerializer' do
    it 'serializes the audit correctly' do
      expect(serialized_audit['id']).to eq(audit.id)
      expect(serialized_audit['auditable_id']).to eq(audit.auditable_id)
      expect(serialized_audit['auditable_type']).to eq(audit.auditable_type)
      expect(serialized_audit['associated_id']).to eq(audit.associated_id)
      expect(serialized_audit['associated_type']).to eq(audit.associated_type)
      expect(serialized_audit['action']).to eq(audit.action)
      expect(serialized_audit['audited_changes']).to eq(audit.audited_changes.as_json)
      expect(serialized_audit['version']).to eq(audit.version)
      expect(serialized_audit['comment']).to eq(audit.comment)
      expect(serialized_audit['remote_address']).to eq(audit.remote_address)
      expect(serialized_audit['user_type']).to eq(audit.user_type)
      expect(serialized_audit['username']).to eq(audit.username)
    end
  end
end
