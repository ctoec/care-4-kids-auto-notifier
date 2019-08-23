require 'rails_helper'

# While this test calls NotificationSendJob, it is more accurately testing the
# custom serializers within the job pipeline. These tests allow us to test the
# sustainability of ActiveJob/DelayedJob storage and retrival.
RSpec.describe NotificationSendJob do
  include ActiveJob::TestHelper

  context 'when a notification is enqueued for later with real ActiveRecord objects' do
    it 'executes from the delayed_jobs table' do
      message_text = 'This is a message'
      cellphonenumber = '+1234567890'
      caseid = rand(100).to_s

      Parent.create(caseid: caseid, cellphonenumber: cellphonenumber)
      notification = Notification.create(message_text: message_text)
      notificationid = notification.id

      notification_event = NotificationEvent.new(caseid, notificationid)

      expect(Sender.count).to eq 0
      perform_enqueued_jobs {
        NotificationSendJob.set(wait: 3.seconds).perform_later(Sender, notification_event)
      }
      expect(Sender.count).to eq 1
    end
  end

  context 'when a notification is enqueued for later with double ActiveRecord objects' do
    it 'executes from the delayed_jobs table' do
      message_text = 'This is a message'
      cellphonenumber = '+1234567890'
      caseid = rand(100).to_s
      notificationid = 1

      # Prepare for ActiveRecord doubles
      ParentCache = Parent
      NotificationCache = Notification
      Object.instance_eval { remove_const :Parent } unless not defined? Parent
      Object.instance_eval { remove_const :Notification } unless not defined? Notification

      # Create ActiveRecord doubles
      parent = double
      allow(parent).to receive(:cellphonenumber).and_return(cellphonenumber)
      Parent = double
      allow(Parent).to receive(:find_by).and_return(parent)

      notification = double
      allow(notification).to receive(:message_text).and_return(message_text)
      Notification = double
      allow(Notification).to receive(:find).and_return(notification)
      
      notification_event = NotificationEvent.new(caseid, notificationid)

      expect(Sender.count).to eq 0
      perform_enqueued_jobs {
        NotificationSendJob.set(wait: 3.seconds).perform_later(Sender, notification_event)
      }
      expect(Sender.count).to eq 1

      expect(Parent).to have_received(:find_by).with(caseid: caseid)
      expect(Notification).to have_received(:find).with(notificationid)

      # Clean up ActiveRecord doubles
      Object.instance_eval { remove_const :Parent } unless not defined? Parent
      Object.instance_eval { remove_const :Notification } unless not defined? Notification
      Parent = ParentCache
      Notification = NotificationCache
    end
  end
end

class Sender
  @@count = 0

  def self.createMessage(*varargs)
    @@count += 1
  end

  def self.count
    cached_count = @@count
    @@count = 0
    cached_count
  end
end
