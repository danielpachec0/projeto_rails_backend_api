require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /authenticate" do
    #let!(:user) { create(user:) }
    let(:user) { create(:user) }

    it 'authenticate a valid user' do
      post '/authenticate', params: { email: user.email, password: user.password}

      expect(response).to have_http_status(:ok)
    end 

    it 'does not authenticate a valid user' do
      post '/authenticate', params: { email: user.email, password: 'wrong password'}

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({
        'error' => {"user_authentication"=>"invalid credentials"}
      })
    end

    it 'returns erro when password is missing' do
      post '/authenticate', params: { email: 'email@email.com'}

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({
        'error' => {"user_authentication"=>"invalid credentials"}
      })
    end

    it 'returns erro when email is missing' do
      post '/authenticate', params: { password: 'abc123'}

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({
        'error' => {"user_authentication"=>"invalid credentials"}
      })
    end
  end
end
