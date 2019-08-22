# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationSendJob do
  context 'when a notification event is supplied' do
    it '.perform is called with the corresponding message and cell phone numbers' do
      message_text = 'This is a message'
      cellphonenumber = '+1234567890'
      caseid = rand(100).to_s

      sender = double
      allow(sender).to receive(:createMessage)

      Parent.create(caseid: caseid, cellphonenumber: cellphonenumber)
      notification = Notification.create(message_text: message_text)

      notification_event = NotificationEvent.new(caseid, notification.id)

      NotificationSendJob.perform_now(sender, notification_event)

      expect(sender).to have_received(:createMessage).exactly(:once)
      expect(sender).to have_received(:createMessage).with(message_text: message_text, to_number: cellphonenumber)
    end
  end
end
