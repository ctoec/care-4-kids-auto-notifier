# frozen_string_literal: true

class NotificationSendJob < ApplicationJob
  queue_as :default

  def perform(sender, notification_event)
    parent = Parent.find_by(caseid: notification_event.caseid)
    notification = Notification.find(notification_event.notificationid)

    sender.createMessage(message_text: notification.message_text,
                         to_number: "+1#{parent.cellphonenumber}")
  end
end
