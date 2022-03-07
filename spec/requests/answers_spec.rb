require 'rails_helper'

def get_token(user)
  token = JsonWebToken.encode(user_id: user.id)
  return token
end

RSpec.describe "Answers api", type: :request do
  let!(:user) { create(:user) }
  let!(:token) { get_token(user) }

  describe 'GET /answers' do

    context 'when user is authenticated' do
  
      before do
        form = create(:formulary)
        question = create(:question, :text, formulary: form)
        create(:answer, question: question, formulary: form)
        create(:answer, question: question, formulary: form)
      end
      it 'return all answers' do
        get answers_url, headers: { Authorization: token }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end
    
    context 'when user is not authenticated' do

      it 'does not authorize the request' do
        get answers_url

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'GET /answers/:id' do
    let!(:answer) { create(:answer, formulary: create(:formulary), question: create(:question, :text, formulary_id: 1)) } 
    
    context 'when user is authenticated' do
      it 'return the specified formulary' do
        get formulary_url(answer.id), headers: { Authorization: token }
        
        expect(response).to have_http_status(:success)
      end
    end
    

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get formulary_url(answer.id)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 

  describe 'POST /answers' do

    context 'when user is authenticated' do

      before do
        create(:formulary)
        create(:question, :text, formulary_id: 1)
      end
      it 'create a new answers' do
        expect {
          post answers_url,
          params: { answer: { content: 'qustion content', formulary_id: 1, question_id: '1' } },
          headers: { Authorization: token }
        }.to change(Answer, :count).from(0).to(1)
        
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'when user is not authenticated' do
      
      it 'does not authorize the request' do
        expect {
          post answers_url,
          params: { answer: { content: 'qustion content', formulary_id: 1, question_id: '1' } }
        }.to_not change(Answer, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'PATCH /answers/:id' do
    let!(:answer) { create(:answer, formulary: create(:formulary), question: create(:question, :text, formulary_id: 1)) } 
 
    context 'when user is authenticated' do
      it 'updates a answer' do
        expect {
          patch answer_url(answer.id),
          params: { answer: { content: 'new content' } },
          headers: { Authorization: token }
        }.to_not change(Answer, :count)

        expect(response).to have_http_status(:ok)
      end  
    end
    
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          patch answer_url(answer.id),
          params: { answer: { content: 'new content' } }
        }.to_not change(Answer, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'DELETE /answers/:id' do
    let!(:answer) { create(:answer, formulary: create(:formulary), question: create(:question, :text, formulary_id: 1)) } 

    context 'when user is authenticated' do
      it 'deletes a answer' do
        expect {
          delete answer_url(answer.id), headers: { Authorization: token } 
        }.to change(Answer, :count).from(1).to(0)

        expect(response).to have_http_status(:no_content)
      end  
    end
    

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
          expect {
            delete answer_url(answer.id)
          }.to_not change(Answer, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 
end