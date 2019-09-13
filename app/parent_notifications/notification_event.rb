# frozen_string_literal: true

class NotificationEvent
  attr :caseid, :notificationid
  
  def initialize(caseid, notificationid)
    @caseid = caseid
    @notificationid = notificationid
  end
end