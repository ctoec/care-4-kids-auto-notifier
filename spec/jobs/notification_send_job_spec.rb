require 'rails_helper'

RSpec.describe NotificationSendJob, :type => :job do
  before do
    stub_const('Twilio::REST::Client', spy)
  end

  describe 'when a notification event is supplied' do  
    it '.perform is called with the corresponding message and cell phone number' do
      client = spy
      allow(Twilio::REST::Client).to receive(:new).and_return(client)
      messages = spy

      notification_event = spy
      
      parent = double
      allow(parent).to receive(:cellphonenumber).and_return('+12345678910')
      Parent = double
      allow(Parent).to receive(:find_by).and_return(parent)

      notification = double
      allow(notification).to receive(:message_text).and_return('This is a message')
      Notification = double
      allow(Notification).to receive(:find).and_return(notification)
      
      NotificationSendJob.perform_now(notification_event)

      expect(messages).to have_received(:create).exactly(:once)
      expect(messages).to have_received(:create).with(any_args)
    end
  end
end
