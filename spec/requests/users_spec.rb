require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_in" do
    it "returns a success response" do
      get new_user_session_path
      expect(response).to be_successful
    end
  end

  describe 'POST /users/sign_in' do
    it 'logs in a user successfully' do
      user = create(:user)
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(root_path)
    end
  end
end
