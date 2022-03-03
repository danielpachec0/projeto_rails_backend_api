require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'factory' do
    context 'when normal factory' do
      it 'be valid' do
        question = build(:question)
        expect(question).to be_valid
      end
    end 
  end
  describe 'validations' do
    context 'when name alwredy is in formulary' do
      before do
        create(:formulary)
        create(:question, name: 'name1', formulary_id: 1)
      end 
      it { expect(build(:question, name: 'name1', formulary_id: 1)).to be_invalid }
    end 
    context 'when same name in another formulary' do
      before do
        create(:formulary)
        create(:question, name: 'name2', formulary_id: 1)
        create(:formulary, name: 'form 2')
      end 
      it { expect(build(:question, name: 'name2', formulary_id: 2)).to be_valid }
    end
  end
end
