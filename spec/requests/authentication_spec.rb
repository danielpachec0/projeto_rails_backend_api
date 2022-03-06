require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /authenticate" do

    let(:user) { create(:user) }

    it 'authenticate the user' do
      post '/authenticate', params: { email: user.email, password: user.password}

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
          'token' => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.0C1bI67LwtiXcxTbF8Rx3u4StxIF2cUKMdUa3oQqNiE"
      })
    end 

    it 'does not authenticate the user when password is incorrect' do
      post '/authenticate', params: { email: user.email, password: "worng password"}

      expect(response).to have_http_status(:unauthorized)
    end 
    
    it 'returns erro when password is missing' do
      post '/authenticate', params: { email: 'email@email.com'}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
          'error' => 'param is missing or the value is empty: password'
      })
    end

    it 'returns erro when email is missing' do
      post '/authenticate', params: { password: 'abc123'}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'error' => 'param is missing or the value is empty: email'
      })
    end
  end
end
