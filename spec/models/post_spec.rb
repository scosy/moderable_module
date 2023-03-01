require "webmock/rspec"
include WebMock::API

RSpec.describe Post, type: :model do
  describe "moderable" do
    let(:post) { FactoryBot.create :post }
    before do
      stub_request(:any, /moderation.logora.fr\/predict/)
        .to_return(status: 200, body: { prediction: { "0": 0.7 } }.to_json)
    end

    it "is not valid if prediction > 0,5" do
      expect(post.is_accepted).to be false
    end
  end
end