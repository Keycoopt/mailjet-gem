#rspec
require 'mailjet_spec_helper'
require 'mailjet/mailer'

describe Mailjet::APIMailer do
  let(:message) { Mail::Message.new }
  subject(:api_mailer) { Mailjet::APIMailer.new }
  
  describe "#deliver!" do
    it "raises an error if the from field of the message contains more than one mailbox specification" do
      message[:from] = "Alain Aqueduc <alain.aqueduc@example.com>, bertrand.bonnet@example.com"
      expect { api_mailer.deliver!(message) }.to raise_error(ArgumentError)
    end
  end
end
