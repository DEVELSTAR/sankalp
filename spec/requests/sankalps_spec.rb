require 'rails_helper'

RSpec.describe "Sankalps", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:sankalp) { create(:sankalp, user: user, category: category) }

  before { sign_in user }

  describe "GET /sankalps" do
    it "returns http success" do
      get sankalps_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's sankalps" do
      sankalp
      get sankalps_path
      expect(response.body).to include(sankalp.title)
    end
  end

  describe "GET /sankalps/:id" do
    it "returns http success for own sankalp" do
      get sankalp_path(sankalp)
      expect(response).to have_http_status(:success)
    end

    it "shows sankalp details" do
      get sankalp_path(sankalp)
      expect(response.body).to include(sankalp.title)
    end

    context "when accessing another user's sankalp" do
      let(:other_user) { create(:user) }
      let(:other_sankalp) { create(:sankalp, user: other_user) }

      it "redirects with unauthorized message" do
        get sankalp_path(other_sankalp)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /sankalps/new" do
    it "returns http success" do
      get new_sankalp_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sankalps" do
    let(:valid_attributes) do
      {
        title: "New Sankalp",
        description: "Test description",
        category_id: category.id,
        start_date: Date.current,
        status: "active"
      }
    end

    it "creates a new sankalp" do
      expect {
        post sankalps_path, params: { sankalp: valid_attributes }
      }.to change(SankalpRecord, :count).by(1)
    end

    it "redirects to the created sankalp" do
      post sankalps_path, params: { sankalp: valid_attributes }
      expect(response).to redirect_to(SankalpRecord.last)
    end

    context "with invalid attributes" do
      it "does not create a sankalp" do
        expect {
          post sankalps_path, params: { sankalp: { title: "" } }
        }.not_to change(SankalpRecord, :count)
      end

      it "renders new template" do
        post sankalps_path, params: { sankalp: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /sankalps/:id" do
    it "updates the sankalp" do
      patch sankalp_path(sankalp), params: { sankalp: { title: "Updated Title" } }
      sankalp.reload
      expect(sankalp.title).to eq("Updated Title")
    end

    it "redirects to the sankalp" do
      patch sankalp_path(sankalp), params: { sankalp: { title: "Updated Title" } }
      expect(response).to redirect_to(sankalp)
    end
  end

  describe "DELETE /sankalps/:id" do
    it "soft deletes the sankalp" do
      sankalp
      expect {
        delete sankalp_path(sankalp)
      }.to change(SankalpRecord, :count).by(-1)
    end

    it "redirects to sankalps index" do
      delete sankalp_path(sankalp)
      expect(response).to redirect_to(sankalps_path)
    end
  end
end
