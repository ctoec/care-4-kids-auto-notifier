class NotificationSendJob < ApplicationJob
  queue_as :default

  def perform(sender, notification_event)
    parent = Applicant.find_by(caseid: notification_event.caseid)
    notification = Notification.find(notification_event.notificationid)

    sender.createMessage(message_text: notification.message_text,
                         to_number: parent.cellphonenumber)
  end
end
