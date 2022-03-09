require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'factory' do

    context 'when it builds a valid user' do
      it { expect(build(:user)).to be_valid }
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

    context 'password have less than 6 characters' do
      it { expect(build(:user, password: nil)).to be_invalid }
    end

    context 'password have only letters' do
      it { expect(build(:user, password: 'ab123')).to be_invalid }
    end

    context 'password have only digits' do
      it { expect(build(:user, password: '123123')).to be_invalid }
    end

    context 'when cpf does no match the regex' do 
      it { expect(build(:user, cpf: "123,123,123-11")).to be_invalid }
    end

    context 'when email is not a valid email adress' do 
      it { expect(build(:user, email: "invalidMail.com")).to be_invalid }
    end

    context 'when email  is not unique' do 
      let(:user) { build(:user, email: 'repeat@mail.com', cpf: '075.494.884-60') }

      before do
        create(:user, email: 'repeat@mail.com')
      end
      it { expect(user).to be_invalid }
    end

    context 'when cpf is not unique' do 
      let(:user) { build(:user, cpf: '379.874.200-69', email: 'email2@mail.com') }

      before do
        create(:user, cpf: '379.874.200-69')
      end
      it { expect(user).to be_invalid }
    end

    context 'when cpf is not a valid cpf' do
      it { expect(build(:user, cpf: '075.494.884-67')).to be_invalid }
    end 
  end 
end
