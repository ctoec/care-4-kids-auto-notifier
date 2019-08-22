NotificationEvent = Struct.new(:caseid, :notificationid)

class NotificationGenerator
  def initialize(document_assigned_events:)
    @document_assigned_events = document_assigned_events
  end

  def fetch_all_new
    @document_assigned_events.fetch_all_new.each do |event|
      found_parent = Applicant.where(caseid: event.caseid).first
      yield build_notification_event(event: event) unless found_parent.nil?
    end
  end

  def build_notification_event(event:)
    notification = Notification.create(
      message_text: "We have received document #{event.type}",
    )
    NotificationEvent.new(event.caseid, notification.id)
  end
end
