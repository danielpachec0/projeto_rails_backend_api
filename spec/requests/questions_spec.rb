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
    context 'Question with type of image' do


    end
    context 'Question with type of text' do

    end
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
    context 'Question with an image' do

      let(:image) { fixture_file_upload('image.png') }
      let(:params) { { question: { name: 'question name', formulary_id: 1, question_type: 'text', image: image } } }
      subject { post questions_url, params: params }
      
      it 'returns ' do
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

    context 'Question without an image' do

      let(:image) { fixture_file_upload('image.png') }
      let(:params) { { question: { name: 'question name', formulary_id: 1, question_type: 'text'} } }
      subject { post questions_url, params: params }

      it 'returns ' do
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
