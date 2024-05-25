require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, role: "admin") }
  # let(:regular_user) { FactoryBot.create(:user) }

  describe "PATCH #block" do
    context "when admin user is logged in" do
      before { sign_in admin_user }

      it "blocks the user" do
        user_to_block = FactoryBot.create(:user)
        patch :block, params: { admin_user_id: admin_user.id, id: user_to_block.id }
        user_to_block.reload
        expect(user_to_block.blocked).to be true
      end
    end

    #   context 'when regular user is logged in' do
    #     before { sign_in regular_user }

    #     it 'does not block the user' do
    #       user_to_block = FactoryBot.create(:user)
    #       patch :block, params: { id: user_to_block.id }
    #       user_to_block.reload
    #       expect(user_to_block.blocked).to be false
    #     end
    #   end
    # end

    # describe 'PATCH #unblock' do
    #   context 'when admin user is logged in' do
    #     before { sign_in admin_user }

    #     it 'unblocks the user' do
    #       user_to_unblock = FactoryBot.create(:user, blocked: true)
    #       patch :unblock, params: { id: user_to_unblock.id }
    #       user_to_unblock.reload
    #       expect(user_to_unblock.blocked).to be false
    #     end
    #   end

    # context 'when regular user is logged in' do
    #   before { sign_in regular_user }

    #   it 'does not unblock the user' do
    #     user_to_unblock = FactoryBot.create(:user, blocked: true)
    #     patch :unblock, params: { id: user_to_unblock.id }
    #     user_to_unblock.reload
    #     expect(user_to_unblock.blocked).to be true
    #   end
    # end
  end

  # Add similar tests for add_admin_role and remove_admin_role actions

end
