require "rails_helper"

RSpec.describe AnswersController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/authenticate").to route_to("authentication#authenticate")
    end
  end
end