require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "POST /authenticate" do
    it 'authenticate the user' do
      post '/authenticate'
    end  
  end
end
