# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationSendJob do
  include ActiveJob::TestHelper

  context 'when a notification event is supplied' do
    it '.perform is called with the corresponding message and cell phone numbers' do
      message_text = 'This is a message'
      cellphonenumber = '2345678900'
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

  context 'when sender throws an error after perform_now' do
    it 'a failed job object is created with corresponding job id, notification id, and parent id' do
      message_text = 'This is a message'
      cellphonenumber = '2345678900'
      caseid = rand(100).to_s
      raised_error = Twilio::REST::RestError.new('Fake error message', Twilio::Response.new(500, ''))

      sender = double
      allow(sender).to receive(:createMessage).and_raise(raised_error)

      parent = Parent.create(caseid: caseid, cellphonenumber: cellphonenumber)
      notification = Notification.create(message_text: message_text)

      notification_event = NotificationEvent.new(caseid, notification.id)

      job = NotificationSendJob.new(sender, notification_event)
      job.perform_now

      expect(FailedJob.all.length).to eq 1

      failed_job = FailedJob.first

      expect(failed_job.notification).to eq notification
      expect(failed_job.parent).to eq parent
      expect(failed_job.jobid).to eq job.job_id
      expect(failed_job.error_code).to eq raised_error.code
    end
  end

  context 'when sender throws an error after perform_later' do
    it 'a failed job object is created with corresponding notification id, and parent id' do
      message_text = 'This is a message'
      cellphonenumber = '2345678900'
      caseid = rand(100).to_s

      parent = Parent.create(caseid: caseid, cellphonenumber: cellphonenumber)
      notification = Notification.create(message_text: message_text)

      notification_event = NotificationEvent.new(caseid, notification.id)

      # This is equivalent to
      # NotificationSendJob.set(wait: 3.seconds).peform_later(TwilioRestErrorSender, notification_event)
      # Constructing it this way allows us to inspect the job object for the id
      job = NotificationSendJob.new(TwilioRestErrorSender, notification_event)
      perform_enqueued_jobs do
        job.enqueue wait: 3.seconds
      end

      expect(FailedJob.all.length).to eq 1

      failed_job = FailedJob.first

      expect(failed_job.notification).to eq notification
      expect(failed_job.parent).to eq parent
      expect(failed_job.jobid).to eq job.job_id
    end
  end
end

class TwilioRestErrorSender
  def self.createMessage(*vargs)
    raise Twilio::REST::RestError.new('Fake error message', Twilio::Response.new(500, ''))
  end
end
