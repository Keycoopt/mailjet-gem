#rspec
require 'mailjet_spec_helper'
require 'mailjet/message_delivery'

describe Mailjet::MessageDelivery do
  describe "#default_headers" do
    specify "content type must be json" do
      expect(Mailjet::MessageDelivery.default_headers).to include content_type: :json
    end
  end
end