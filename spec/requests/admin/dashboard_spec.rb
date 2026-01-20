require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin" do
    context "when not logged in" do
      it "redirects to login" do
        get admin_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in as regular user" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "redirects to root with unauthorized message" do
        get admin_root_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when logged in as admin" do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it "returns http success" do
        get admin_root_path
        expect(response).to have_http_status(:success)
      end

      it "displays dashboard statistics" do
        get admin_root_path
        expect(response.body).to include("Admin Dashboard")
      end
    end
  end
end
