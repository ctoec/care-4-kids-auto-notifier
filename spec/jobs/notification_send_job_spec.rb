require 'rails_helper'

RSpec.describe NotificationSendJob, :type => :job do
  include ActiveJob::TestHelper

  message_text = 'This is a message'
  to_number = '+1234567890'

  before(:all) do
    ApplicantCache = Applicant
    NotificationCache = Notification
  end

  before(:each) do
    Object.instance_eval { remove_const :Applicant } unless not defined? Applicant
    Object.instance_eval { remove_const :Notification } unless not defined? Notification

    parent = double
    allow(parent).to receive(:cellphonenumber).and_return(to_number)
    Applicant = double
    allow(Applicant).to receive(:find_by).and_return(parent)

    notification = double
    allow(notification).to receive(:message_text).and_return(message_text)
    Notification = double
    allow(Notification).to receive(:find).and_return(notification)
  end
  
  after(:each) do
    Object.instance_eval { remove_const :Applicant } unless not defined? Applicant
    Object.instance_eval { remove_const :Notification } unless not defined? Notification
  end

  after(:all) do
    Applicant = ApplicantCache
    Notification = NotificationCache
  end

  context 'when a notification event is supplied' do  
    it '.perform is called with the corresponding message and cell phone numbers' do
      sender = double
      allow(sender).to receive(:createMessage)

      notification_event = spy

      NotificationSendJob.perform_now(sender, notification_event)

      expect(sender).to have_received(:createMessage).exactly(:once)
      expect(sender).to have_received(:createMessage).with(message_text: message_text, to_number: to_number)
    end
  end

  context 'when a notification is enqueued for later' do
    it 'executes from the delayed_jobs table' do
      notification_event = NotificationEvent.new("123", 1) # caseid, notificationid

      expect(Sender.count).to eq 0
      perform_enqueued_jobs {
        NotificationSendJob.set(wait: 3.seconds).perform_later(Sender, notification_event)
      }
      expect(Sender.count).to eq 1
    end
  end
end

class Sender
  @@count = 0

  def self.createMessage(*varargs)
    @@count += 1
  end

  def self.count
    @@count
  end
end