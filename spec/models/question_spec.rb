require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'factory' do

    context 'when normal factory' do
      it { expect(build(:question, :text)).to be_valid  }
    end

    context 'when normal factory' do
      it { expect(build(:question, :image)).to be_valid  }
    end 
  end

  describe 'validations' do

    context 'when name is null' do
      it { expect(build(:question, :text, name: nil)).to be_invalid }
    end 

    context 'when question_type is null' do
      it { expect(build(:question, :text, question_type: nil)).to be_invalid }
    end 

    context 'when formulary_id is null' do
      it { expect(build(:question, :text, name: 'name1', formulary_id: nil)).to be_invalid }
    end 

    context 'when formulary_id does not match a formulary in the db' do
      it { expect(build(:question, :text, name: 'name1', formulary_id: 10)).to be_invalid }
    end 

    context 'when name alwredy is in formulary' do
      before do
        create(:formulary)
        create(:question, :text, name: 'name1', formulary_id: 1)
      end 
      it { expect(build(:question, :text, name: 'name1', formulary_id: 1)).to be_invalid }
    end 

    context 'when same name in another formulary' do
      before do
        create(:formulary)
        create(:question, :text, name: 'name2', formulary_id: 1)
        create(:formulary, name: 'form 2')
      end 
      it { expect(build(:question, :text, name: 'name2', formulary_id: 2)).to be_valid }
    end

    context 'when question_type is not valid' do
      before do
        create(:formulary)
      end
        it { expect(build(:question, :text, question_type: 'invalid type', formulary_id: 1)).to be_invalid }
    end

    context 'when type is image but image is nil' do
      before do
        create(:formulary)
      end
        it { expect(build(:question, :image, formulary_id: 1, image: nil)).to be_invalid }
    end

    context 'when type is image and text is not nil' do
      before do
        create(:formulary)
      end
        it { expect(build(:question, :image ,formulary_id: 1, text: 'big text')).to be_invalid }
    end

    context 'when type is text but text is nil' do
      before do
        create(:formulary)
      end
        it { expect(build(:question, :text, formulary_id: 1, text: nil)).to be_invalid }
    end

    context 'when type is text and image is not nil' do
      let(:image) { fixture_file_upload('image.png') }

      before do
        create(:formulary)
      end
        it { expect(build(:question, :text ,formulary_id: 1, image: image)).to be_invalid }
    end
  end
end
