require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'factory' do
    context 'when normal factory' do
      it 'be valid' do
        form = create(:formulary)
        question = create(:question, :text, formulary: form)
        answer = build(:answer, question: question, formulary: form)
        expect(answer).to be_valid
      end
    end 
  end
  describe 'validations' do
    context 'When the question_id is nil' do 
      it 'dows not create a new answer' do
        form = create(:formulary)
        answer = build(:answer, formulary: form)
        expect(answer).to be_invalid
      end
    end
    context 'When the formulary_id is nil' do 
      it 'dows not create a new answer' do
        question = create(:question, :text)
        answer = build(:answer, question: question)
        expect(answer).to be_invalid
      end
    end
  end
end
