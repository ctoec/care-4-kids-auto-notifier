require 'rails_helper'

RSpec.describe NotificationSendJob, :type => :job do
  describe 'when a notification event is supplied' do  
    it '.perform is called with the corresponding message and cell phone numbers' do
      message_text = 'This is a message'
      to_number = '+1234567890'
      from_number = nil # Because ENV is not configured
      
      sender = double
      allow(sender).to receive(:createMessage)

      notification_event = spy
      
      parent = double
      allow(parent).to receive(:cellphonenumber).and_return(to_number)
      Parent = double
      allow(Parent).to receive(:find_by).and_return(parent)

      notification = double
      allow(notification).to receive(:message_text).and_return(message_text)
      Notification = double
      allow(Notification).to receive(:find).and_return(notification)
      
      NotificationSendJob.perform_now(sender, notification_event)

      expect(sender).to have_received(:createMessage).exactly(:once)
      expect(sender).to have_received(:createMessage).with(message_text: message_text, to_number: to_number, from_number: from_number)
    end
  end
end
