require 'rails_helper'

def get_token(user)
  token = JsonWebToken.encode(user_id: user.id)
  return token
end

RSpec.describe "Visits", type: :request do
  let!(:user) { create(:user) }
  let(:token) { get_token(user) }
  
  describe 'GET /visits' do

    context 'when user is authenticated' do
      before do
        create(:visit, user_id: 1)
        create(:visit, user_id: 1)
      end
      it 'return all visits' do
        get visits_url, headers: { Authorization: token }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get visits_url

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'GET /visit/:id' do
    let!(:visit) { create(:visit, user_id: 1) } 

    context 'when user is authenticated' do
      it 'return the specified user' do
        get visit_url(visit.id), headers: { Authorization: token }
        
        expect(JSON.parse(response.body)["id"]).to eq(visit.id)
        expect(response).to have_http_status(:success)
      end
    end 

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get visit_url(visit.id)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'POST /visits' do

    context 'when user is authenticated' do

      context 'when attributes are valid' do
        it 'Creates a new visit' do
          expect {
            post visits_url,
            params: { visit: { date: DateTime.current, status: 'realizando', user_id: 1, checkin_at: DateTime.yesterday,  checkout_at:  DateTime.tomorrow.tomorrow} },
            headers: { Authorization: token }
          }.to change(Visit, :count).from(0).to(1)

          expect(response).to have_http_status(:created)
        end
      end

      context 'when attributes are invalid' do
        it 'does not create a valid visit' do
          expect {
            #passes an invalid user id
            post visits_url,
            params: { visit: { date: DateTime.current, status: 'status', user_id: 2, checkin_at: DateTime.yesterday,  checkout_at:  DateTime.tomorrow.tomorrow} },
            headers: { Authorization: token }
          }.to_not change(User, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end 
      end

      context 'when user is not authenticated' do
        it 'does not authorize the request' do
          expect {
            post visits_url,
            params: { visit: { date: DateTime.current, status: 'realizando', user_id: 1, checkin_at: DateTime.yesterday,  checkout_at:  DateTime.tomorrow.tomorrow} }
          }.to_not change(Visit, :count)

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            'error' => 'Not Authorized'
          })
        end
      end
    end
    
    
  end

  describe 'PATCH /visit/:id' do
    let!(:visit) { create(:visit, user_id: 1) } 

    context 'when user is authenticated' do
      it 'updates a visit' do
        expect {
          patch visit_url(visit.id),
          params: { visit: { status: 'pendente' } },
          headers: { Authorization: token }  
        }.to_not change(User, :count)

        expect(response).to have_http_status(:ok)
      end
    end 
      

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        patch visit_url(visit.id), params: { visit: { status: 'pendente' } }
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'DELETE /visit/:id' do
    let!(:visit) { create(:visit, user_id: 1) } 
    let!(:visit2) { create(:visit, user_id: 1) } 
    let!(:question) { create(:question, :text) } 
    let!(:answer) { create(:answer, formulary_id: 1, question_id: 1, visit_id: 2) }

    context 'when user is authenticated' do
      it 'deletes a visit' do
        expect {
          delete visit_url(visit.id), headers: { Authorization: token }
        }.to change(Visit, :count).from(2).to(1)

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes a visit with a dependent answer' do
        expect {
          delete visit_url(visit2.id), headers: { Authorization: token }
        }.to change(Visit, :count).from(2).to(1)

        expect(response).to have_http_status(:no_content)
      end
    end 

   

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          delete visit_url(visit2.id)
        }.to_not change(Visit, :count)
        
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 
end