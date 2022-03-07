require 'rails_helper'

def get_token(user)
  token = JsonWebToken.encode(user_id: user.id)
  return token
end

describe 'Users api', type: :request do
  let!(:user) { create(:user) }
  let(:token) { get_token(user) }

  describe 'GET /users' do
    
    before do
      create(:user, email: 'email2@mail.com', cpf: '379.874.200-69')
    end
    context 'when user is authenticated' do
      it 'return all users' do
        get users_url, headers: { Authorization: token } 

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get users_url 

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end 
    
  end
  
  describe 'GET /user/:id' do

    context 'when user is authenticated' do
      it 'return the specified user' do
        get user_url(user.id), headers: { Authorization: token } 
        
        expect(JSON.parse(response.body)["id"]).to eq(user.id)
        expect(response).to have_http_status(:success)
      end
    end 
    

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get user_url(user.id) 

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end 
  end 

  describe 'POST /users' do

    context 'when attributes are valid' do
      it 'create a new user' do
        expect {
          post users_url,
          params: { user: { name: 'daniel', email: 'daniel@mail.com', cpf: '379.874.200-69', password: 'abc123'} }
        }.to change(User, :count).from(1).to(2)
        
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'when attributes are not valid' do
      it 'does not create a valid user' do
        expect {
          post users_url, params: { user: {  email: 'daniel@mail.com', cpf: '111.222.333-11'} }
        }.to_not change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end 
    end
    
  end

  describe 'PATCH /user/:id' do

    context 'when user is authenticated' do
      it 'updates a user' do
        expect {
          patch user_url(user.id),
          params: { user: { name: 'anna', password: 'abc123' } },
          headers: { Authorization: token } 
        }.to_not change(User, :count)

        expect(response).to have_http_status(:ok)
      end  
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          patch user_url(user.id),
          params: { user: { name: 'anna', password: 'abc123' } }
        }.to_not change(User, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end 
  end

  describe 'DELETE /user/:id' do
    let!(:user) { create(:user) } 
    
    context 'when user is authenticated' do
      it 'deletes a user' do
        expect {
          delete user_url(user.id), headers: { Authorization: token }
        }.to change(User, :count).from(1).to(0)

        expect(response).to have_http_status(:no_content)
      end

      before do
        create(:visit, user_id: 1)
      end
      it 'deletes a user with a dependent visit' do
        expect {
          delete user_url(user.id), headers: { Authorization: token }
        }.to change(User, :count).from(1).to(0)
  
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          delete user_url(user.id)
        }.to_not change(User, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 
end