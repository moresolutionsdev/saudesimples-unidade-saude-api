# frozen_string_literal: true

RSpec.shared_context 'with an authenticated token' do
  let(:access_token) { 'token' }
  let(:authenticated_user) do
    {
      id: '1',
      email: 'jonh.doe@test.com',
      session_id: '123'
    }
  end
  let(:decoded_token) do
    [
      authenticated_user,
      {
        'alg' => 'RS256',
        'kid' => '123',
        'typ' => 'JWT'
      }
    ]
  end

  let!(:current_user) { create(:usuario, id: authenticated_user[:id], email: authenticated_user[:email]) }

  before do
    request.headers['Authorization'] = "Bearer #{access_token}"
    allow(AutenticacaoGem::Jwt::Decoder).to receive(:call).with(access_token).and_return(decoded_token)
  end
end

RSpec.shared_context 'with a invalid token' do
  let(:access_token) { 'invalid_token' }
  let(:authenticated_user) { nil }
  let(:decoded_token) { nil }
  let(:current_user) { nil }

  before do
    request.headers['Authorization'] = "Bearer #{access_token}"
    allow(AutenticacaoGem::Jwt::Decoder).to receive(:call).with(access_token).and_raise(JWT::DecodeError)
  end
end
