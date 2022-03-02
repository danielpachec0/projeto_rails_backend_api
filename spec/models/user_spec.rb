require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'factory' do
    context 'when normal factory' do
      it 'be valid' do
        user = build(:user)
        expect(user).to be_valid
      end
    end 
  end 
  describe 'validation' do
    context 'when name is nil' do 
      it { expect(build(:user, name: nil)).to be_invalid }
    end
    context 'when email is nil' do 
      it { expect(build(:user, email: nil)).to be_invalid }
    end
    context 'when cpf is nil' do 
      it { expect(build(:user, cpf: nil)).to be_invalid }
    end
    context 'when cpf size is smaller than accepted' do 
      it { expect(build(:user, cpf: "123")).to be_invalid }
    end
    context 'when cpf size is bigger than accepted' do 
      it { expect(build(:user, cpf: "1234567891011")).to be_invalid }
    end
    context 'when email is not a valid email adress' do 
      it { expect(build(:user, email: "invalidMail")).to be_invalid }
    end
    context 'when an user atributte is not unique' do 
      it 'email is not unique' do
        create(:user, email: 'repeat@mail.com')
        user = build(:user, email: 'repeat@mail.com', cpf: '11111111111')
        expect(user).to be_invalid
      end
      it 'cpf is not unique' do
        create(:user, cpf: '37987420069')
        user = build(:user, cpf: "37987420069", email: 'email2@mail.com')
        expect(user).to be_invalid 
      end
    end
    context 'when cpf is not a valid cpf' do
      it { expect(build(:user, cpf: '07549488467')).to be_invalid }
    end 
  end 
end
