require 'rails_helper'


RSpec.describe "Questions api", type: :request do
  describe 'GET /questions' do
    before do
      create(:question)
      create(:formulary, name: '2')
      create(:question, formulary_id: 2, name: 'other question')
    end
    it 'return all formularies' do
      get questions_url
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
end
