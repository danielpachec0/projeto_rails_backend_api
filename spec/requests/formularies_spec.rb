require 'rails_helper'

describe 'Formularies api', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { get_token(user) }

  describe 'GET /formularies' do
    before do
      create(:formulary)
      create(:formulary, name: 'other form')
    end
    it 'return all formularies' do
      get formularies_url, headers: { Authorization: token }
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /formularies/:id' do
    let!(:form) { create(:formulary) } 
    it 'return the specified formulary' do
      get formulary_url(form.id), headers: { Authorization: token }
      
      expect(response).to have_http_status(:success)
    end
  end 

  describe 'POST /formularies' do
    it 'create a new formulary' do
      expect {
        post formularies_url,
        params: { formulary: { name: 'fomr name' } },
        headers: { Authorization: token }
      }.to change(Formulary, :count).from(0).to(1)
      

      expect(response).to have_http_status(:created)
      
    end
  end

  describe 'PATCH /formularies/:id' do
    let!(:form) { create(:formulary) } 

    it 'updates a formulary' do
      expect {
      patch formulary_url(form.id),
      params: { formulary: { name: 'new form' } },
      headers: { Authorization: token }
      }.to_not change(Formulary, :count)

      expect(response).to have_http_status(:ok)
    end  
  end

  describe 'DELETE /formularies/:id' do
    let!(:form) { create(:formulary) } 

    it 'deletes a formulary' do
      expect {
        delete formulary_url(form.id), headers: { Authorization: token } 
      }.to change(Formulary, :count).from(1).to(0)

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