require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "validates the presence of username" do
      user = User.new(email: "test@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "validates the uniqueness of username" do
      User.create!(username: "testuser", email: "test@example.com", password: "password")
      user = User.new(username: "testuser", email: "another@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it "validates the presence of email" do
      user = User.new(username: "testuser", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "validates the uniqueness of email" do
      User.create!(username: "testuser", email: "test@example.com", password: "password")
      user = User.new(username: "anotheruser", email: "test@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "successfully creates a user with valid attributes" do
      user = User.new(username: "newuser", email: "new@example.com", password: "password")
      expect(user).to be_valid
    end
  end

  describe "default role" do
    it "defaults to regular role for new users" do
      user = User.new(username: "testuser", email: "test@example.com", password: "password")
      expect(user.role).to eq("regular")
    end
  end

  describe "role assignment" do
    it "allows setting role to admin" do
      user = User.new(username: "adminuser", email: "admin@example.com", password: "password", role: :admin)
      expect(user.role).to eq("admin")
    end
  end
end
