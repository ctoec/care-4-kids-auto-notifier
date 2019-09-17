# frozen_string_literal: true

class NotificationGenerator
  def initialize(document_assigned_events:)
    @document_assigned_events = document_assigned_events
  end

  def fetch_all_new
    @document_assigned_events.fetch_all_new.each do |event|
      found_parent = Parent.where(caseid: event.caseid).first
      if parent_is_active(found_parent)
        yield build_notification_event(event: event)
        found_parent.increment_notifications_count!
        yield build_instructions_reminder_event(event: event) if found_parent.send_follow_up?
      end
    end
  end

  def build_notification_event(event:)
    notification = Notification.create(
      message_text: build_document_received_message(
        type: event.type, source: event.source, date: event.date
      )
    )
    NotificationEvent.new(event.caseid, notification.id)
  end

  def build_instructions_reminder_event(event:)
    notification = Notification.create(
      message_text: "You can text STATUS for information on Care 4 Kids processing dates. Questions or feedback about these notifications? Text QUESTION anytime to retrieve this link: http://bit.ly/Care4KidsPilot. Text REMOVE to stop participating in the pilot program and receiving notifications."
    )
    NotificationEvent.new(event.caseid, notification.id)
  end

  def parent_is_active(parent)
    !parent.nil? and parent.active
  end
  
  def build_document_received_message(type:, source:, date:)
    <<-string.gsub(/\s+/, " ").strip
      This is Care 4 Kids!
      We have received your #{type}
      by #{source}
      on #{date.strftime('%m/%d/%Y')}.
      You will be notified if there is any missing information.
    string
  end
end
