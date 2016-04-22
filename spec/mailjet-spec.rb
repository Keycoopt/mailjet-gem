#rspec
require 'mailjet_spec_helper'

describe Mailjet do
  describe 'simple GET requests' do
    it 'calls Contact.all without parameters' do
      res = Mailjet::Contact.all()
      expect(res).not_to be_nil
    end

    it 'calls Contact.all with valid parameters' do
      res = Mailjet::Contact.all(limit: 2)
      expect(res[0].attributes['email']).not_to be_nil
    end

    it 'calls Contact.all with invalid parameters' do
      res = Mailjet::Contact.all(invalid: 0)
      expect(res[0].attributes['email']).not_to be_nil
    end

    it 'calls Contact.first' do
      res = Mailjet::Contact.first
      expect(res.attributes['email']).not_to be_nil
    end

    it 'calls Contact.find with numeric ID' do
      res = Mailjet::Contact.find(5771382)
      expect(res.attributes['email']).not_to be_nil
    end

    it 'calls Contact.find with Unique Key id' do
      expect do
        Mailjet::Contact.find('test@mailjet.com')
      end.not_to raise_error
    end

    it 'calls Contact.count' do
      res = Mailjet::Contact.count
      expect(res).not_to be_nil
    end

  end

end
