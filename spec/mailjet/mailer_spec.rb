#rspec
require 'mailjet_spec_helper'
require 'mailjet/mailer'

describe Mailjet::APIMailer do
  let(:message) { Mail::Message.new from: "Alain Aqueduc <alain.aqueduc@example.com>" }
  subject(:api_mailer) { Mailjet::APIMailer.new }
  
  describe "#deliver!" do
    it "raises an error if the from field of the message contains more than one mailbox specification" do
      message[:from] = "Alain Aqueduc <alain.aqueduc@example.com>, bertrand.bonnet@example.com"
      expect { api_mailer.deliver!(message) }.to raise_error(ArgumentError)
    end
    
    specify "The payload sent to Mailjet::MessageDelivery contains both a :from_name and a :from_email keys" do
      message[:from] = "Alain Aqueduc <alain.aqueduc@example.com>"
      allow(Mailjet::MessageDelivery).to receive(:create)
      
      api_mailer.deliver!(message)
      
      expect(Mailjet::MessageDelivery).to have_received(:create).with hash_including from_name: "Alain Aqueduc", from_email: "alain.aqueduc@example.com"
    end
    
    specify "the payload sent to Mailjet::MessageDelivery contains the message's attachments" do
      message.add_file(filename: "test.txt", content:  "Lorem ipsum dolor sit amet")

      allow(Mailjet::MessageDelivery).to receive(:create)
      
      api_mailer.deliver!(message)
      
      expect(Mailjet::MessageDelivery).to have_received(:create).with hash_including attachments: [{'Content-Type' => 'text/plain', 'Filename' => 'test.txt', 'content' => anything}]
    end
    
    specify "content of the message's attachments into the payload must be base 64 encoded" do
      message.add_file(filename: "test.txt", content: "Lorem ipsum dolor sit amet")

      allow(Mailjet::MessageDelivery).to receive(:create)
      
      api_mailer.deliver!(message)
      
      expect(Mailjet::MessageDelivery).to have_received(:create).with hash_including attachments: [hash_including('content' => "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQ=\n")]
    end
  end
end
