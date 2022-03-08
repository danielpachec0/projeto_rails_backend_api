require 'rails_helper'

RSpec.describe Visit, type: :model do
  
  describe 'Factory' do
    
    context 'when normal factory' do
      it { expect(build(:visit, user: create(:user))).to be_valid  }
    end 
  end
  
  describe 'validations' do

    context 'when date is nil' do 
      it { expect(build(:visit, date: nil, user: create(:user))).to be_invalid }
    end

    context 'when status is nil' do 
      it { expect(build(:visit, status: nil, user: create(:user))).to be_invalid }
    end

    context 'when status is not a valid option' do 
      it { expect(build(:visit, status: 'invalid status', user: create(:user))).to be_invalid }
    end

    context 'when user_id is nil' do 
      it { expect(build(:visit, user_id: nil, user: create(:user))).to be_invalid }
    end

    context 'when checkin_at is nil' do 
      it { expect(build(:visit, checkin_at: nil, user: create(:user))).to be_invalid }
    end

    context 'when checkout_at is nil' do 
      it { expect(build(:visit, checkout_at: nil, user: create(:user))).to be_invalid }
    end

    context 'when date is before the current date and' do 
      it { expect(build(:visit, date: DateTime.yesterday, user: create(:user))).to be_invalid }
    end

    context 'when checkin_at is after the current date or before checkout_at' do 
      it { expect(build(:visit, checkin_at: DateTime.tomorrow, user: create(:user))).to be_invalid }
    end

    context 'when checkout_at is before than checkin_at' do 
      it { expect(build(:visit, checkout_at: DateTime.yesterday.yesterday, user: create(:user))).to be_invalid }
    end

    context 'when user_id does not match a registered user' do 
      it { expect(build(:visit, user_id: 1)).to be_invalid }
    end
  end  
end
