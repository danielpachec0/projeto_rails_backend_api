require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  describe "POST /authenticate" do
    let(:user) { create(:user) }

    context 'when credentials are valid' do
      it 'authenticate the user user' do
        post '/authenticate', params: { email: user.email, password: user.password}
  
        expect(response).to have_http_status(:ok)
      end 
    end 
    
    context 'when crendentials are invalid' do
      it 'does not authenticate the user' do
        post '/authenticate', params: { email: user.email, password: 'wrong password'}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => {"user_authentication"=>"invalid credentials"}
        })
      end
    end

    
    context 'when a paramtter is missing' do
      it 'returns error when password is missing' do
        post '/authenticate', params: { email: 'email@email.com'}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => {"user_authentication"=>"invalid credentials"}
        })
      end

      it 'returns error when email is missing' do
        post '/authenticate', params: { password: 'abc123'}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => {"user_authentication"=>"invalid credentials"}
        })
      end
    end
  end    
end
