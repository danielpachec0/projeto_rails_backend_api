require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'factory' do

    context 'when normal factory' do
      let(:form) { create(:formulary) }
      let(:question) { create(:question, :text, formulary: form) }
      let(:answer) { build(:answer, question: question, formulary: form) }

      it { expect(answer).to be_valid }
    end 
  end

  describe 'validations' do

    let(:form) { create(:formulary) }
    let(:question) { create(:question, :text) }

    context 'When the question_id is nil' do 
      let(:answer) { build(:answer, formulary: form, question_id: nil) }

      it { expect(answer).to be_invalid  }
    end

    context 'When the formulary_id is nil' do 
      let(:answer) { build(:answer, question: question, formulary_id: nil) }

      it { expect(answer).to be_invalid  }
    end

    context 'when the question do not belong to the formulary' do
      let!(:form) { create(:formulary) }
      let!(:other_form) { create(:formulary, name: "other form") }
      let!(:question) { create(:question, :text, formulary_id: 2) }
      let(:answer) {build(:answer, question_id: 1, formulary_id: 1)}

      it { expect(answer).to be_invalid  }
    end
  end
end