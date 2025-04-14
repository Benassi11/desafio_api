require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid without an password' do
    user = build(:user, password: nil)
    expect(user).not_to be_valid  
  end

  it 'If the admin is null' do
    user = build(:user, is_admin: nil)
    expect(user).to be_valid  
  end

  it 'If the admin is false' do
    user = build(:user, is_admin: false)
    expect(user).to be_valid
  end

  it 'If the admin is true' do
    user = build(:user, is_admin: true)
    expect(user).to be_valid
  end
end
