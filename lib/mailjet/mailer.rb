require 'action_mailer'
require 'mail'

class Mailjet::Mailer < ::Mail::SMTP
  def initialize(options = {})
    ActionMailer::Base.default(:from => Mailjet.config.default_from) if Mailjet.config.default_from.present?
    super({
      :address  => "in-v3.mailjet.com",
      :port  => 587,
      :authentication  => 'plain',
      :user_name => Mailjet.config.api_key,
      :password  => Mailjet.config.secret_key,
      :enable_starttls_auto => true
    }.merge(options))
  end
end

ActionMailer::Base.add_delivery_method :mailjet, Mailjet::Mailer



class Mailjet::APIMailer
  def initialize(options = {})
    ActionMailer::Base.default(:from => Mailjet.config.default_from) if Mailjet.config.default_from.present?
    @delivery_method_options = options.slice(:'mj-prio', :'mj-campaign', :'mj-deduplicatecampaign', :'mj-trackopen', :'mj-trackclick', :'mj-customid', :'mj-eventpayload', :'header')
  end

  def deliver!(mail)
    raise ArgumentError, "the message's from field has more than one mailbox specification (#{mail.from.join(', ')})" if mail.from.size > 1

    if mail.multipart?
      content = {
        :text => mail.text_part.try(:decoded),
        :html => mail.html_part.try(:decoded),
        :attachments => mail.attachments.reject{ |a| a.inline? }.map do |a|
          { "Content-Type"  => a.mime_type, "Filename" => a.filename, "content" => a.body }
        end,
        :inlineattachment => mail.attachments.select{ |a| !a.inline? }.try(:decoded)
      }
    else
      content = (mail.mime_type == "text/html") ? {:html => mail.body.decoded} : {:text => mail.body.decoded}
    end
    
    from = if mail[:from]
              mail[:from].addrs.first
            else
              Mail::Address.new(Mailjet.config.default_from)
            end
    payload = {
      :from_email => from.address,
      :from_name => from.display_name,
      :sender => mail.sender,
      :to => mail.to,
      :reply_to => mail.reply_to,
      :cc => mail.cc,
      :bcc => mail.bcc,
      :subject => mail.subject,
      :'mj-customid' => mail['X-MJ-CustomID'] && mail['X-MJ-CustomID'].value,
      :'mj-eventpayload' => mail['X-MJ-EventPayload'] && mail['X-MJ-EventPayload'].value
    }.merge(content).merge(@delivery_method_options)

    Mailjet::MessageDelivery.create(payload)
  end
end

ActionMailer::Base.add_delivery_method :mailjet_api, Mailjet::APIMailer
