require 'rails_helper'

RSpec.describe Formulary, type: :model do
  describe 'factory' do

    context 'when normal factory' do
      it { expect(build(:formulary)).to be_valid  }
    end 
  end

  describe 'validations' do

    context 'when name is not unique' do 
      before do
        create(:formulary) 
      end 
      it { expect(build(:formulary)).to be_invalid  }
    end

    context 'when name is nil' do 
      it { expect(build(:formulary, name: nil)).to be_invalid  }
    end
  end 
end
