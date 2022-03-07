require 'rails_helper'

def get_token(user)
  token = JsonWebToken.encode(user_id: user.id)
  return token
end

describe 'Formularies api', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { get_token(user) }

  describe 'GET /formularies' do

    context 'when user is authenticated' do

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
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get formularies_url

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'GET /formularies/:id' do
    let!(:form) { create(:formulary) } 

    context 'when user is authenticated' do
      it 'return the specified formulary' do
        get formulary_url(form.id), headers: { Authorization: token }
        
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do

        get formulary_url(form.id)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 

  describe 'POST /formularies' do
    
    context 'when user is authenticated' do
      it 'create a new formulary' do
        expect {
          post formularies_url,
          params: { formulary: { name: 'fomr name' } },
          headers: { Authorization: token }
        }.to change(Formulary, :count).from(0).to(1)
        
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          post formularies_url,
          params: { formulary: { name: 'fomr name' } }
        }.to_not change(Formulary, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'PATCH /formularies/:id' do
    let!(:form) { create(:formulary) } 

    context 'when user is authenticated' do
      it 'updates a formulary' do
        expect {
          patch formulary_url(form.id),
          params: { formulary: { name: 'new form' } },
          headers: { Authorization: token }
        }.to_not change(Formulary, :count)

        expect(response).to have_http_status(:ok)
      end 
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          patch formulary_url(form.id),
          params: { formulary: { name: 'new form' } }
        }.to_not change(Formulary, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'DELETE /formularies/:id' do
    let!(:form) { create(:formulary) } 
    let!(:form2) { create(:formulary, name: 'form 2') } 
    let!(:question) { create(:question, :text, formulary_id: 2) }

    context 'when user is authenticated' do
      it 'deletes a formulary' do
        expect {
          delete formulary_url(form.id), headers: { Authorization: token } 
        }.to change(Formulary, :count).from(2).to(1)

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes a formulary with a question' do
        expect {
          delete formulary_url(form2.id), headers: { Authorization: token } 
        }.to change(Formulary, :count).from(2).to(1)

        expect(response).to have_http_status(:no_content)
      end
    end
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          delete formulary_url(form.id)
        }.to_not change(Formulary, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 
end