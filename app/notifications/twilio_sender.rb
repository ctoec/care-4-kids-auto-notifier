# frozen_string_literal: true

require 'twilio-ruby'

class TwilioSender
  @@account_sid = ENV.fetch 'TWILIO_ACCOUNT_SID'
  @@auth_token = ENV.fetch 'TWILIO_AUTH_TOKEN'
  @@from = ENV.fetch 'C4K_SMS_NUMBER'

  @@client = Twilio::REST::Client.new(@@account_sid, @@auth_token)

  def self.createMessage(message_text:, to_number:)
    @@client.messages.create(
      from: @@from,
      to: to_number,
      body: message_text
    )
  end
end
