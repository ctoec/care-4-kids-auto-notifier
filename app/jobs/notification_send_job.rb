# frozen_string_literal: true

class NotificationSendJob < ApplicationJob
  queue_as :default

  retry_on StandardError, attempts: 1 do |job, error|
    notification_event = job.get_notification_event
    caseid = notification_event.caseid
    notificationid = notification_event.notificationid
    parent = Parent.find_by!(caseid: caseid)
    
    is_success = FailedJob.create(jobid: job.job_id, notification_id: notificationid, parent_id: parent.id)
    Rails.logger.error( 
      "Could not create failed job record. Notification ID: #{notificationid}, Case ID: #{caseid}"
    ) unless is_success

    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Could not find parent with Case ID: #{caseid}"
    rescue => e
      Rails.logger.error e
      raise e
  end

  def perform(sender, notification_event)
    parent = Parent.find_by(caseid: notification_event.caseid)
    notification = Notification.find(notification_event.notificationid)

    sender.createMessage(message_text: notification.message_text,
                         to_number: parent.cellphonenumber)
  end

  def get_notification_event()
    # arguments is [sender, notification_event]
    self.arguments[1]
  end
end
