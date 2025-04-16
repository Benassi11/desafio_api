require 'rails_helper'

RSpec.describe User, type: :model do
  context "validating attributes" do
    it 'checking valid attributes user' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'checking valid attributes user_is_admin' do
      user = build(:user, :user_admin)
      expect(user).to be_valid
    end
  end

  describe "Email" do
    context "when email is present" do
      it 'returns true when save user' do
        user = build(:user, email: "exemplo@exemplo.com.br")
        expect(user.save).to eq(true)
      end
    end

    context "when email is not present" do
      it 'returns false when save user' do
        user = build(:user, email: nil)
        expect(user.save).to eq(false)
      end

      it 'returns an error message' do
        user = build(:user, email: nil)
        user.save
        expect(user.errors.messages[:email]).to include("can't be blank")
      end
    end

    context "unique email" do
      it 'checking is invalid with a duplicate email' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).not_to be_valid
      end
    end
  end

  describe "password" do
    context "when password is present" do
      it 'returns true when save user' do
        user = build(:user, password: "123123")
        expect(user.save).to eq(true)
      end
    end

    context "when password is not present" do
      it 'returns false when save user' do
        user = build(:user, password: nil)
        expect(user.save).to eq(false)
      end

      it 'returns an error message' do
        user = build(:user, password: nil)
        user.save
        expect(user.errors.messages[:password]).to include("can't be blank")
      end
    end

    context "Validated password" do
      it 'checking authenticates with correct password' do
        user = create(:user, password: '123123')
        expect(user.valid_password?('123123')).to be_truthy
      end

      it 'checking does not authenticate with incorrect password' do
        user = build(:user, password: '123123', password_confirmation: '321321')
        user.save
        expect(user.save).to eq(false)
      end

      it 'checking does not authenticate with incorrect password' do
        user = build(:user, password: '123123', password_confirmation: '321321')
        user.save
        expect(user.errors.messages[:password_confirmation]).to include("doesn't match Password")
      end
    end
  end
  describe "User_admin" do
    context "when admin flag is false or true" do
      it 'flag false' do
        user = create(:user, is_admin: false)
        expect(user).to be_valid
      end

       it 'flag true' do
        user = create(:user, is_admin: true)
        expect(user).to be_valid
      end
    end
  end
end
