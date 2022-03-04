require 'rails_helper'

RSpec.describe Formulary, type: :model do
  describe 'factory' do
    context 'when normal factory' do
      it 'be valid' do
        form = build(:formulary)
        expect(form).to be_valid
      end
    end 
  end
  describe 'validations' do
    context 'when name is not unique' do 
      it 'does not create a new formulary' do
        create(:formulary)
        form = build(:formulary)
        expect(form).to be_invalid
      end
    end
  end 
end
