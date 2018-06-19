require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    # request.env["HTTP_ACCEPT"] = 'application/json'
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    before(:each) do
      @member_attributes = attributes_for(:member)
      post :create, params: {member: @member_attributes}
    end

    it "Redirect to new member" do
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/members/#{Member.last.id}")
    end

    it "Create member with right attributes" do
      expect(Member.last.name).to eql(@member_attributes[:name])
      expect(Member.last.email).to eql(@member_attributes[:email])
      expect(Member.last.campaign_id).to eql(@member_attributes[:campaign_id])
      expect(Member.last.open).to eql('false')
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Campaign Owner" do
      it "returns http success" do
        member = create(:member, user: @current_user)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:success)
      end
    end

    context "User isn't the Campaign Owner" do
      it "returns http forbidden" do
        campaign = create(:member)
        delete :destroy, params: {id: member.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @new_member_attributes = attributes_for(:member)
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "User is the Campaign Owner" do
      before(:each) do
        member = create(:member, user: @current_user)
        put :update, params: {id: member.id, member: @new_member_attributes}
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "Member has the new attributes" do
        expect(Member.last.name).to eql(@member_attributes[:name])
        expect(Member.last.email).to eql(@member_attributes[:email])
        expect(Member.last.campaign_id).to eql(@member_attributes[:campaign_id])
        expect(Member.last.open).to eql('false')
    end

    context "User isn't the Campaign Owner" do
      it "returns http forbidden" do
        member = create(:member)
        put :update, params: {id: member.id, member: @new_member_attributes}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end
