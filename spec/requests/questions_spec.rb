require 'rails_helper'


RSpec.describe "Questions api", type: :request do
  describe 'GET /questions' do
    before do
      create(:question)
      create(:formulary, name: '2')
      create(:question, formulary_id: 2, name: 'other question')
    end
    it 'return all questions' do
      get questions_url
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /Question/:id' do
    let!(:question) { create(:question) } 
    it 'return the specified formulary' do
      get formulary_url(question.id)
      
      expect(response).to have_http_status(:success)
    end
  end 

  describe 'POST /questions' do
    before do
      create(:formulary)
    end
    it 'create a new question' do
      expect {
        post questions_url, params: { question: { name: 'question name', formulary_id: 1, question_type: 'text' } }
      }.to change(Question, :count).from(0).to(1)
      

      expect(response).to have_http_status(:created)
      
    end
  end

  describe 'PATCH /questions/:id' do
    let!(:question) { create(:question) } 

    it 'updates a question' do
      expect {
        patch question_url(question.id), params: { question: { name: 'new name' } }  
      }.to_not change(Question, :count)

      expect(response).to have_http_status(:ok)
    end  
  end

  describe 'DELETE /questions/:id' do
    let!(:question) { create(:question) } 

    it 'deletes a question' do
      expect {
        delete question_url(question.id) 
      }.to change(Question, :count).from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end 
end
