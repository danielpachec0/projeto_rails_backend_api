require 'rails_helper'

describe 'Users api', type: :request do
  describe 'GET /users' do
    before do
      create(:user)
      create(:user, email: 'email2@mail.com', cpf: '37987420069')
    end
    it 'return all users' do
      
      get users_url
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
  describe 'GET /user/:id' do
    let!(:user) { create(:user) } 
    it 'return the specified user' do
      get user_url(user.id)
      
      expect(response).to have_http_status(:success)
    end
  end 
  describe 'POST /users' do
    it 'create a new user' do
      expect {
        post users_url, params: { user: { name: 'daniel', email: 'daniel@mail.com', cpf: '37987420069'} }
      }.to change(User, :count).from(0).to(1)
      

      expect(response).to have_http_status(:created)
      
    end
    it 'does not create a valid user' do
      expect {
        post users_url, params: { user: {  email: 'daniel@mail.com', cpf: '11122233311'} }
      }.to_not change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end 
  end

  describe 'PATCH /user/:id' do
    let!(:user) { create(:user) } 

    it 'updates a user' do
      expect {
      patch user_url(user.id), params: { user: { name: 'anna' } }  
      }.to_not change(User, :count)

      expect(response).to have_http_status(:ok)
    end  
  end

  describe 'DELETE /user/:id' do
    let!(:user) { create(:user) } 

    it 'deletes a user' do
      expect {
        delete user_url(user.id) 
      }.to change(User, :count).from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end 
end
