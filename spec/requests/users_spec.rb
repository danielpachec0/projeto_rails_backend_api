require 'rails_helper'

describe 'Users api', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { get_token(user) }

  describe 'GET /users' do
    before do
      create(:user, email: 'email2@mail.com', cpf: '379.874.200-69')
    end
    it 'return all users' do
      
      get users_url, headers: { Authorization: token } 

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
  
  describe 'GET /user/:id' do
    it 'return the specified user' do
      get user_url(user.id), headers: { Authorization: token } 
      
      expect(response).to have_http_status(:success)
    end
  end 
  describe 'POST /users' do
    it 'create a new user' do
      expect {
        post users_url,
        params: { user: { name: 'daniel', email: 'daniel@mail.com', cpf: '379.874.200-69', password: 'abc123'} }
      }.to change(User, :count).from(1).to(2)
      

      expect(response).to have_http_status(:created)
      
    end
    it 'does not create a valid user' do
      expect {
        post users_url, params: { user: {  email: 'daniel@mail.com', cpf: '111.222.333-11'} }
      }.to_not change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end 
  end

  describe 'PATCH /user/:id' do

    it 'updates a user' do
      expect {
      patch user_url(user.id),
      params: { user: { name: 'anna', password: 'abc123' } },
      headers: { Authorization: token } 
      }.to_not change(User, :count)

      expect(response).to have_http_status(:ok)
    end  
  end

  describe 'DELETE /user/:id' do
    let!(:user) { create(:user) } 

    it 'deletes a user' do
      expect {
        delete user_url(user.id), headers: { Authorization: token }
      }.to change(User, :count).from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end 
end

def get_token(user)
  post '/authenticate', params: { email: user.email, password: user.password}
  token = JSON.parse(response.body)
  t =   token["auth_token"] 
  return t
end