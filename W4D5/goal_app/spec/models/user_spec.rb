# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    FactoryBot.build(:user)
  end

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it {should validate_presence_of(:session_token)}
  it {should validate_length_of(:password).is_at_least(6)}
  it {should have_many(:goals)}

  describe "#password=" do
    it "sets a session token" do
      expect(FactoryBot.build(:user).session_token).not_to be_nil
    end
  end

  describe "is_password?" do
    it "verifies that an entered password is correct" do
      user = FactoryBot.build(:user)
      password = user.password
      user.save!
      expect(BCrypt::Password.new(user.password_digest).is_password?(password)).to be true
    end
  end

  describe "ensure_session_token" do
    context "when session token exists" do
      it "returns session token" do
        session_token = user.session_token
        expect(user.ensure_session_token).to eq(session_token)
      end
    end

    context "when session token does not exist" do
      it "sets session token when none exists" do
        user.session_token = nil
        expect(user.ensure_session_token).not_to be_nil
      end
    end
  end

  describe "reset_session_token!" do
    it "resets the session token" do
      session_token1 = user.session_token
      expect(user.reset_session_token!).not_to eq(session_token1)
    end
  end

  describe "find_by_credentials" do
    it "finds the user" do
      user.save!
      expect(User.find_by_credentials(user.username, user.password)).to eq(user)
    end
  end


end
