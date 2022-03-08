require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'factory' do

    context 'when it builds a valid answer with a visit' do
      let(:form) { create(:formulary) }
      let(:question) { create(:question, :text, formulary: form) }
      let(:visit) { create(:visit, user: create(:user))}
      let(:answer) { build(:answer, question: question, formulary: form, visit: visit) }
      
      it { expect(answer).to be_valid }
    end 

    context 'when it builds a valid answer without a visit' do
      let(:form) { create(:formulary) }
      let(:question) { create(:question, :text, formulary: form) }
      let(:answer) { build(:answer, question: question, formulary: form) }
      
      it { expect(answer).to be_valid }
    end 
  end

  describe 'validations' do

    let!(:form) { create(:formulary) }
    let!(:question) { create(:question, :text, formulary_id: 1) }

    context 'When the question_id is nil' do 
      let(:answer) { build(:answer, formulary: form, question_id: nil) }

      it { expect(answer).to be_invalid  }
    end

    context 'When the formulary_id is nil' do 
      let(:answer) { build(:answer, question: question, formulary_id: nil) }

      it { expect(answer).to be_invalid  }
    end

    context 'When the formulary_id does not match valid a formulary in the db' do 
      let(:answer) { build(:answer, question: question, formulary_id: 10) }

      it { expect(answer).to be_invalid  }
    end

    context 'When the question_id does not match a question in the db' do 
      let(:answer) { build(:answer, formulary: form, question_id: 10) }

      it { expect(answer).to be_invalid  }
    end

    context 'When the question_id does not match a question in the db' do 
      let(:answer) { build(:answer, formulary: form, question: question) }

      it { expect(answer).to be_valid  }
    end

    context 'when the question do not belong to the formulary' do
      let(:form) { create(:formulary, name: 'form10') }
      let(:other_form) { create(:formulary, name: 'form 20') }
      let(:question) { create(:question, :text, formulary: form) }
      let(:answer) {build(:answer, question: question, formulary: other_form)}

      it { expect(answer).to be_invalid  }
    end
  end
end