require 'rails_helper'

def get_token(user)
  token = JsonWebToken.encode(user_id: user.id)
  return token
end

RSpec.describe "Questions api", type: :request do
  let!(:user) { create(:user) }
  let!(:token) { get_token(user) }

  describe 'GET /questions' do

    context 'when user is authenticated' do
      
      before do
        create(:question, :text)
        create(:formulary, name: '2')
        create(:question, :text, formulary_id: 2, name: 'other question')
      end
      it 'return all questions' do
        get questions_url, headers: { Authorization: token }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get questions_url

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'GET /Question/:id' do
    let!(:question) { create(:question, :text) } 
    
    context 'when user is authenticated' do
      it 'return the specified question' do
        get formulary_url(question.id), headers: { Authorization: token }
        
        expect(JSON.parse(response.body)["id"]).to eq(question.id)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        get questions_url(question.id)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 

  describe 'POST /questions' do

    context 'when user is authenticated' do
    
      before do
        create(:formulary)
      end
      context 'Question with question_type of image' do

        let(:image) { fixture_file_upload('image.png') }
        let(:params) { { question: { name: 'question name', formulary_id: 1, question_type: 'image', image: image } } }
        subject { post questions_url, params: params, headers: { Authorization: token } }
        
        it 'returns status ok' do
          subject
          expect(response).to have_http_status :created
        end
        it 'creates a question' do
          expect { subject }.to change { Question.count }.from(0).to(1)
        end
        it 'creates a blob for the image' do
          expect { subject }.to change { ActiveStorage::Blob.count }.from(0).to(1)
        end 
      end

      context 'Question with question_type of text' do

        let(:image) { fixture_file_upload('image.png') }
        let(:params) { { question: { name: 'question name', formulary_id: 1, question_type: 'text', text: 'a big text'} } }
        subject { post questions_url, params: params, headers: { Authorization: token } }

        it 'returns status ok' do
          subject
          expect(response).to have_http_status :created
        end
        it 'creates a question' do
          expect { subject }.to change { Question.count }.from(0).to(1)
        end
        it 'does not create a blob for the image' do
          expect { subject }.to_not change { ActiveStorage::Blob.count }
        end 
      end  
    end
    
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect{
          post questions_url, params: { name: 'question name', formulary_id: 1, question_type: 'text', text: 'a big text'}
        }.to_not change{ Question.count }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'PATCH /questions/:id' do
    let!(:question) { create(:question, :text) } 

    context 'when user is authenticated' do
      it 'updates a question' do
        expect {
          patch question_url(question.id),
          params: { question: { name: 'new name' } },
          headers: { Authorization: token }
        }.to_not change(Question, :count)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          patch question_url(question.id),
          params: { question: { name: 'new name' } }
        }.to_not change(Question, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end

  describe 'DELETE /questions/:id' do
    let!(:question) { create(:question, :text) } 
    let!(:question2) { create(:question, :text, name: 'new question', formulary_id: 1 ) } 
    let!(:answer) { create(:answer, formulary_id: 1, question_id: 2) }

    context 'when user is authenticated' do
      it 'deletes a question' do
        expect {
          delete question_url(question.id), headers: { Authorization: token }
        }.to change(Question, :count).from(2).to(1)

        expect(response).to have_http_status(:no_content)
      end

      it 'delete a question with an answer' do
        expect {
          delete question_url(question2.id), headers: { Authorization: token }
        }.to change(Question, :count).from(2).to(1)
      end
    end
    
    
    context 'when user is not authenticated' do
      it 'does not authorize the request' do
        expect {
          delete question_url(question.id)
        }.to_not change(Question, :count)

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error' => 'Not Authorized'
        })
      end
    end
  end 
end