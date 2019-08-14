require 'twilio-ruby'

class NotificationSendJob < ApplicationJob
  queue_as :default

  @@account_sid = ENV.fetch 'TWILIO_ACCOUNT_SID'
  @@auth_token = ENV.fetch 'TWILIO_AUTH_TOKEN'
  @@from = ENV.fetch 'TWILIO_SMS_NUMBER'

  @@client = Twilio::REST::Client.new(@@account_sid, @@auth_token)

  def perform(notification_event)
    caseid = notification_event.caseid
    notificationid = notification_event.notificationid

    parent = Parent.find_by(caseid: caseid)
    notification = Notification.find(notificationid)

    to = parent.cellphonenumber
    message_text = notification.message_text
    
    @@client.messages.create(
      from: @@from,
      to: to,
      body: message_text
    )
  end
end
