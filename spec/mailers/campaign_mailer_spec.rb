require "rails_helper"

RSpec.describe CampaignMailer, type: :mailer do
  describe "raffle" do

    before do
      @campaign = create(:campaign)
      @member   = create(:member, campaign: @campaign)
      @friend = create(:member, campaign: @campaign)
      @mail = CampaignMailer.raffle(@campaign, @member, @friend)
    end


    it "renders the headers" do
      expect(@mail.subject).to eq("Nosso Amigo Secreto: #{@campaign.title}")
      expect(@mail.to).to eq([@member.email])
    end

    it "body has member name" do
      expect(@mail.body.encoded).to match(@member.name)
    end

    it "body has campaign creator name" do
      expect(@mail.body.encoded).to match(@campaign.user.name)
    end

    it "body has campaign friend name" do
      expect(@mail.body.encoded).to match(@friend.name)
    end

    it "body has member link to set open" do
      expect(@mail.body.encoded).to match("/members/#{@member.token}/opened")
    end
  end

end
