# frozen_string_literal: true

RSpec.describe Api::AuditsController do
  describe 'GET #index' do
    subject { response }

    include_context 'with an authenticated token'

    before do
      ActiveRecord::Base.connection.reset_pk_sequence!('usuarios')
      ActiveRecord::Base.connection.reset_pk_sequence!('audits')

      users = [user1, user2]
      create_list(:audit, 10, auditable: unidade_saude).each_with_index do |audit, i|
        audit.update!(user_id: users[i % 2].id, user_type: 'Usuario')
        audit.update!(audited_changes: [Faker::Internet.email],
                      created_at: Faker::Time.between(from: 2.years.ago, to: 2.months.ago))
      end
    end

    let!(:unidade_saude) { create(:unidade_saude) }
    let!(:user1) { create(:usuario, email: 'gluz@teste.com') }
    let!(:user2) { create(:usuario, email: 'shanks@akagami.com') }

    it 'returns paginated response' do
      get :index, params: { id: unidade_saude.id, page: 1, per_page: 5 }

      parsed_body = response.parsed_body

      expect(parsed_body['data'].size).to eq(5)
      expect(parsed_body['meta']['total_pages']).to be_present
      expect(parsed_body['meta']['total_count']).to be_present
      expect(parsed_body['meta']['current_page']).to be_present
    end

    it 'returns data with user associated' do
      get :index, params: { id: unidade_saude.id }

      parsed_body = response.parsed_body

      expect(parsed_body['data']).not_to be_nil
      expect(parsed_body['data']).to all(include('user'))

      parsed_body['data'].each do |audit|
        if audit['user'].present?
          expect(audit['user']).to be_present
          expect(audit['user']['email']).to be_present
        else
          expect(audit['user']).to be_nil
        end
      end
    end
  end
end
