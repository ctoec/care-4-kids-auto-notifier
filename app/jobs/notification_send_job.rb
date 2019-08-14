class NotificationSendJob < ApplicationJob
  queue_as :default

  @@from = ENV['C4K_SMS_NUMBER']

  def perform(sender, notification_event)
    caseid = notification_event.caseid
    notificationid = notification_event.notificationid

    parent = Parent.find_by(caseid: caseid)
    notification = Notification.find(notificationid)

    to = parent.cellphonenumber
    message_text = notification.message_text
    
    sender.createMessage(message_text: message_text, to_number: to, from_number: @@from)
  end
end
