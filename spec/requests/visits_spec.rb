require 'rails_helper'

RSpec.describe "Visits", type: :request do
  describe 'GET /visits' do
    before do
      create(:visit)
      create(:visit, user_id: 1)
    end
    it 'return all visits' do
      get visits_url

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /visits' do
    before do
      create(:user)
    end
    it 'Creates a new visit' do
      
      expect {
        post visits_url, params: { visit: { date: DateTime.current, status: 'status', user_id: 1, checkin_at: DateTime.yesterday,  checkout_at:  DateTime.tomorrow.tomorrow} }
      }.to change(Visit, :count).from(0).to(1)


      expect(response).to have_http_status(:created)
    end
  end
end
