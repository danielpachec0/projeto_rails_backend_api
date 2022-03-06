require 'rails_helper'

RSpec.describe AuthenticationTokenService do
    describe '.call' do
        let(:token) { described_class.call('1') }
        it 'returns an authenticated token' do
            decode_token = JWT.decode(
                token,
                described_class::HMAC_SECRET,
                true,
                { algorithm: described_class::ALGORITHM_TYPE }
            )

            expect(decode_token).to eq([
                {"user_id"=>"1"},
                {"alg"=>"HS256", "typ"=>"JWT"}
            ])
        end 
    end 
end